//
//  RNCustomAuthSdk.swift
//  RNCustomAuthSdk
//
//  Created by Shubham on 1/12/20.
//

import CustomAuth
import Foundation

@available(iOS 13.0, *)
@objc(RNCustomAuthSdk)
public class RNCustomAuthSdk: NSObject {
    var tdsdk: CustomAuth?
    var directAuthArgs: CustomAuthArgs?
    var sub: [SubVerifierDetailsWebSDK] = []

    @objc public func initialize(_ params: [String: Any]) {
        directAuthArgs = try! JSONDecoder().decode(CustomAuthArgs.self, from: JSONSerialization.data(withJSONObject: params))
    }

    @MainActor @objc public func triggerLogin(_ params: [String: Any], resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
        Task{
            if directAuthArgs == nil {
                reject("400", "triggerLogin: ", "Call .initialize first")
            }
            
            do {
                let subverifierWeb = try JSONDecoder().decode(SubVerifierDetailsWebSDK.self, from: JSONSerialization.data(withJSONObject: params))
                let browserType: URLOpenerTypes = URLOpenerTypes(rawValue: subverifierWeb.browserType ?? "") ?? .asWebAuthSession
                let sub = SubVerifierDetails(loginType: SubVerifierType(rawValue: subverifierWeb.webOrInstalled ?? "") ?? .web,
                                             loginProvider: LoginProviders(rawValue: subverifierWeb.typeOfLogin)!,
                                             clientId: subverifierWeb.clientId,
                                             verifier: subverifierWeb.verifier,
                                             redirectURL: directAuthArgs!.redirectUri,
                                             browserRedirectURL: directAuthArgs!.browserRedirectUri,
                                             jwtParams: subverifierWeb.jwtParams ?? [:])
                tdsdk = CustomAuth(aggregateVerifierType: .singleLogin, aggregateVerifier: subverifierWeb.verifier, subVerifierDetails: [sub], network: directAuthArgs!.nativeNetwork, loglevel: .info, enableOneKey: directAuthArgs?.enableOneKey ?? false,networkUrl: directAuthArgs?.networkUrl)
                    let vc = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController
                    do{
                        let data = try await self.tdsdk!.triggerLogin(controller: vc, browserType: browserType)
                        resolve(data)
                    }catch {
                        reject("400", "triggerLogin: ", error)
                    }
            }
            catch let err as NSError {
                print("JSON decode failed: \(err.localizedDescription)")
                reject("400", "triggerLogin: ", err.localizedDescription)
            }
        }
    }
    @MainActor @objc public func triggerAggregateLogin(_ params: [String: Any], resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
        Task{
            if directAuthArgs == nil {
                reject("400", "triggerAggregateLogin: ", "Call .initialize first")
            }
            
            do {
                let aggregateVerifierWeb = try JSONDecoder().decode(AggregateLoginParamsWebSDK.self, from: JSONSerialization.data(withJSONObject: params))
                let subverifierWeb = aggregateVerifierWeb.subVerifierDetailsArray[0]
                let browserType: URLOpenerTypes = URLOpenerTypes(rawValue: subverifierWeb.browserType ?? "") ?? .asWebAuthSession
                let sub = SubVerifierDetails(loginType: SubVerifierType(rawValue: subverifierWeb.webOrInstalled ?? "") ?? .web,
                                             loginProvider: LoginProviders(rawValue: subverifierWeb.typeOfLogin)!,
                                             clientId: subverifierWeb.clientId,
                                             verifier: subverifierWeb.verifier,
                                             redirectURL: directAuthArgs!.redirectUri,
                                             browserRedirectURL: directAuthArgs!.browserRedirectUri,
                                             jwtParams: subverifierWeb.jwtParams ?? [:])
                
                tdsdk = CustomAuth(aggregateVerifierType: verifierTypes(rawValue: aggregateVerifierWeb.aggregateVerifierType)!, aggregateVerifier: aggregateVerifierWeb.verifierIdentifier, subVerifierDetails: [sub], network: directAuthArgs!.nativeNetwork, loglevel: .info, enableOneKey: directAuthArgs?.enableOneKey ?? false,networkUrl: directAuthArgs?.networkUrl)
                let vc = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController
                do{
                    let data = try await self.tdsdk!.triggerLogin(controller: vc, browserType: browserType)
                    resolve(data)
                }catch {
                    reject("400", "triggerAggregateLogin: ", error)
                }
                
            } catch let err as NSError {
                print("JSON decode failed: \(err.localizedDescription)")
                reject("400", "triggerAggregateLogin: ", err.localizedDescription)
            }
        }
    }

    @objc public class func handle(_ url: String) {
        CustomAuth.handle(url: URL(string: url)!)
    }

    @MainActor @objc public func getTorusKey(_ verifier: String, verifierId: String, verifierParams: [String: Any]?, idToken: String, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
        Task{
            if directAuthArgs == nil {
                reject("400", "getTorusKey: ", "Call .initialize first")
                return
            }
            
            tdsdk = CustomAuth(aggregateVerifierType: .singleLogin, aggregateVerifier: verifier, subVerifierDetails: [], network: directAuthArgs!.nativeNetwork, loglevel: .info, enableOneKey: directAuthArgs?.enableOneKey ?? false)
            
            do{
                let data = try await self.tdsdk!.getTorusKey(verifier: verifier, verifierId: verifierId, idToken: idToken, userData: [:])
                resolve(data)
            }catch {
                reject("400", "getTorusKey: ", error.localizedDescription)
            }
        }
    }

   @MainActor @objc public func getAggregateTorusKey(_ verifier: String, verifierId: String, subVerifierInfoArray: Array<[String: String]>, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
       Task{
           if directAuthArgs == nil {
               reject("400", "getAggregateTorusKey: ", "Call .initialize first")
               return
           }
           
           do {
               let subverifierInfoWebArray = try subVerifierInfoArray.map(decodeTorusSubVerifierInfoWebSDK)
               
               if subverifierInfoWebArray.isEmpty {
                   throw "subVerifierInfoArray cannot be empty"
               }
               
               tdsdk = CustomAuth(aggregateVerifierType: .singleIdVerifier, aggregateVerifier: verifier, subVerifierDetails: [], network: directAuthArgs!.nativeNetwork, loglevel: .info, enableOneKey: directAuthArgs?.enableOneKey ?? false,networkUrl: directAuthArgs?.networkUrl)
               
               do{
                   let data = try await self.tdsdk!.getAggregateTorusKey(verifier: verifier, verifierId: verifierId, idToken: subverifierInfoWebArray[0].idToken, subVerifierDetails: SubVerifierDetails(loginProvider: .jwt, clientId: "", verifier: verifier, redirectURL: "https://app.tor.us"))
                   resolve(data)
               }catch {
                   reject("400", "getAggregateTorusKey: ", error)
               }
               
           } catch let err as NSError {
               print("JSON decode failed: \(err.localizedDescription)")
               reject("400", "getAggregateTorusKey: ", err.localizedDescription)
           } 
       }
    }

    @objc
    static func requiresMainQueueSetup() -> Bool {
        return true
    }
}

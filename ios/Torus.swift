//
//  RNCustomAuthSdk.swift
//  RNCustomAuthSdk
//
//  Created by Shubham on 1/12/20.
//

import CustomAuth
import Foundation
import PromiseKit

@available(iOS 13.0, *)
@objc(RNCustomAuthSdk)
public class RNCustomAuthSdk: NSObject {
    var tdsdk: CustomAuth?
    var directAuthArgs: CustomAuthArgs?
    var sub: [SubVerifierDetailsWebSDK] = []

    @objc public func initialize(_ params: [String: Any]) {
        directAuthArgs = try! JSONDecoder().decode(CustomAuthArgs.self, from: JSONSerialization.data(withJSONObject: params))
    }

    @objc public func triggerLogin(_ params: [String: Any], resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
        if directAuthArgs == nil {
            reject("400", "triggerLogin: ", "Call .initialize first")
        }

        do {
            let subverifierWeb = try JSONDecoder().decode(SubVerifierDetailsWebSDK.self, from: JSONSerialization.data(withJSONObject: params))

            let sub = SubVerifierDetails(loginType: SubVerifierType(rawValue: subverifierWeb.webOrInstalled!)!,
                                         loginProvider: LoginProviders(rawValue: subverifierWeb.typeOfLogin)!,
                                         clientId: subverifierWeb.clientId,
                                         verifierName: subverifierWeb.verifier,
                                         redirectURL: directAuthArgs!.redirectUri,
                                         browserRedirectURL: directAuthArgs!.browserRedirectUri,
                                         extraQueryParams: subverifierWeb.queryParameters ?? [:],
                                         jwtParams: subverifierWeb.jwtParams ?? [:])
            tdsdk = CustomAuth(aggregateVerifierType: .singleLogin, aggregateVerifierName: subverifierWeb.verifier, subVerifierDetails: [sub], network: directAuthArgs!.nativeNetwork, loglevel: .info, enableOneKey: directAuthArgs?.enableOneKey ?? false)

            DispatchQueue.main.async {
                self.tdsdk!.triggerLogin(browserType: .external).done { data in
                    resolve(data)
                }.catch { err in
                    reject("400", "triggerLogin: ", err)
                }
            }

        } catch let err as NSError {
            print("JSON decode failed: \(err.localizedDescription)")
            reject("400", "triggerLogin: ", err.localizedDescription)
        }
    }

    @objc public func triggerAggregateLogin(_ params: [String: Any], resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
        if directAuthArgs == nil {
            reject("400", "triggerAggregateLogin: ", "Call .initialize first")
        }

        do {
            let aggregateVerifierWeb = try JSONDecoder().decode(AggregateLoginParamsWebSDK.self, from: JSONSerialization.data(withJSONObject: params))
            let subverifierWeb = aggregateVerifierWeb.subVerifierDetailsArray[0]

            let sub = SubVerifierDetails(loginType: SubVerifierType(rawValue: subverifierWeb.webOrInstalled!)!,
                                         loginProvider: LoginProviders(rawValue: subverifierWeb.typeOfLogin)!,
                                         clientId: subverifierWeb.clientId,
                                         verifierName: subverifierWeb.verifier,
                                         redirectURL: directAuthArgs!.redirectUri,
                                         browserRedirectURL: directAuthArgs!.browserRedirectUri,
                                         extraQueryParams: subverifierWeb.queryParameters ?? [:],
                                         jwtParams: subverifierWeb.jwtParams ?? [:])

            tdsdk = CustomAuth(aggregateVerifierType: verifierTypes(rawValue: aggregateVerifierWeb.aggregateVerifierType)!, aggregateVerifierName: aggregateVerifierWeb.verifierIdentifier, subVerifierDetails: [sub], network: directAuthArgs!.nativeNetwork, loglevel: .info, enableOneKey: directAuthArgs?.enableOneKey ?? false)

            DispatchQueue.main.async {
                self.tdsdk!.triggerLogin(browserType: .external).done { data in
                    resolve(data)
                }.catch { err in
                    reject("400", "triggerAggregateLogin: ", err)
                }
            }

        } catch let err as NSError {
            print("JSON decode failed: \(err.localizedDescription)")
            reject("400", "triggerAggregateLogin: ", err.localizedDescription)
        }
    }

    @objc public class func handle(_ url: String) {
        CustomAuth.handle(url: URL(string: url)!)
    }

    @objc public func getTorusKey(_ verifier: String, verifierId: String, verifierParams: [String: Any]?, idToken: String, extraParams: [String: Any]?, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
        if directAuthArgs == nil {
            reject("400", "getTorusKey: ", "Call .initialize first")
            return
        }

        tdsdk = CustomAuth(aggregateVerifierType: .singleLogin, aggregateVerifierName: verifier, subVerifierDetails: [], network: directAuthArgs!.nativeNetwork, loglevel: .info, enableOneKey: directAuthArgs?.enableOneKey ?? false)

        DispatchQueue.main.async {
            self.tdsdk!.getTorusKey(verifier: verifier, verifierId: verifierId, idToken: idToken, userData: extraParams ?? [:]).done { data in
                resolve(data)
            }.catch { err in
                reject("400", "getTorusKey: ", err.localizedDescription)
            }
        }
    }

    @objc public func getAggregateTorusKey(_ verifier: String, verifierId: String, subVerifierInfoArray: Array<[String: String]>, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
        if directAuthArgs == nil {
            reject("400", "getAggregateTorusKey: ", "Call .initialize first")
            return
        }

        do {
            let subverifierInfoWebArray = try subVerifierInfoArray.map(decodeTorusSubVerifierInfoWebSDK)

            if subverifierInfoWebArray.isEmpty {
                throw "subVerifierInfoArray cannot be empty"
            }

            tdsdk = CustomAuth(aggregateVerifierType: .singleIdVerifier, aggregateVerifierName: verifier, subVerifierDetails: [], network: directAuthArgs!.nativeNetwork, loglevel: .info, enableOneKey: directAuthArgs?.enableOneKey ?? false)

            DispatchQueue.main.async {
                self.tdsdk!.getAggregateTorusKey(verifier: verifier, verifierId: verifierId, idToken: subverifierInfoWebArray[0].idToken, subVerifierDetails: SubVerifierDetails(loginProvider: .jwt, clientId: "", verifierName: verifier, redirectURL: "https://app.tor.us")).done { data in
                    resolve(data)
                }.catch { err in
                    reject("400", "getAggregateTorusKey: ", err)
                }
            }

        } catch let err as NSError {
            print("JSON decode failed: \(err.localizedDescription)")
            reject("400", "getAggregateTorusKey: ", err.localizedDescription)
        }
    }

    @objc
    static func requiresMainQueueSetup() -> Bool {
        return true
    }
}

//
//  RNTorusDirectSdk.swift
//  RNTorusDirectSdk
//
//  Created by Shubham on 1/12/20.
//

import Foundation
import TorusSwiftDirectSDK
import PromiseKit
import BestLogger

@available(iOS 11.0, *)
@objc(RNTorusDirectSdk)
public class RNTorusDirectSdk: NSObject {
    var tdsdk: TorusSwiftDirectSDK?
    var directAuthArgs: DirectWebSDKArgs?
    var sub: [SubVerifierDetailsWebSDK] = []
    
    @objc public func initialize(_ params: [String: Any]){
        self.directAuthArgs = try! JSONDecoder().decode(DirectWebSDKArgs.self, from: JSONSerialization.data(withJSONObject: params))
    }
    
    @objc public func triggerLogin(_ params: [String:Any], resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock){
        if(self.directAuthArgs == nil){
            reject("400", "triggerLogin: ", "Call .initialize first")
        }
        
        do{
            let subverifierWeb = try JSONDecoder().decode(SubVerifierDetailsWebSDK.self, from: JSONSerialization.data(withJSONObject: params))
            
            let sub = SubVerifierDetails(loginType: SubVerifierType(rawValue: subverifierWeb.webOrInstalled!)!,
                                         loginProvider: LoginProviders(rawValue: subverifierWeb.typeOfLogin)!,
                                         clientId: subverifierWeb.clientId,
                                         verifierName: subverifierWeb.verifier,
                                         redirectURL: self.directAuthArgs!.redirectUri,
                                         browserRedirectURL: self.directAuthArgs!.browserRedirectUri,
                                         extraQueryParams: subverifierWeb.queryParameters ?? [:],
                                         jwtParams: subverifierWeb.jwtParams ?? [:])
            
            var logvalue: Int = 5
            if(self.directAuthArgs!.enableLogging != nil && self.directAuthArgs!.enableLogging == true){
                logvalue = 0
            }
            
            self.tdsdk = TorusSwiftDirectSDK(aggregateVerifierType: .singleLogin, aggregateVerifierName: subverifierWeb.verifier, subVerifierDetails: [sub], loglevel: BestLogger.Level(rawValue: logvalue)!)
            
            self.tdsdk!.triggerLogin(browserType: .external).done{ data in
                resolve(data)
            }.catch{ err in
                reject("400", "triggerLogin: ", err)
            }
            
        }catch let err as NSError {
            print("JSON decode failed: \(err.localizedDescription)")
            reject("400", "triggerLogin: ", err.localizedDescription)
        }
        
        
    }
    
    @objc public func triggerAggregateLogin(_ params: [String:Any], resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock){
        if(self.directAuthArgs == nil){
            reject("400", "triggerAggregateLogin: ", "Call .initialize first")
        }
        
        do{
            let aggregateVerifierWeb = try JSONDecoder().decode(AggregateLoginParamsWebSDK.self, from: JSONSerialization.data(withJSONObject: params))
            let subverifierWeb = aggregateVerifierWeb.subVerifierDetailsArray[0]
            
            let sub = SubVerifierDetails(loginType: SubVerifierType(rawValue: subverifierWeb.webOrInstalled!)!,
                                         loginProvider: LoginProviders(rawValue: subverifierWeb.typeOfLogin)!,
                                         clientId: subverifierWeb.clientId,
                                         verifierName: subverifierWeb.verifier,
                                         redirectURL: self.directAuthArgs!.redirectUri,
                                         browserRedirectURL: self.directAuthArgs!.browserRedirectUri,
                                         extraQueryParams: subverifierWeb.queryParameters ?? [:],
                                         jwtParams: subverifierWeb.jwtParams ?? [:])
            
            var logvalue: Int = 5
            if(self.directAuthArgs!.enableLogging != nil && self.directAuthArgs!.enableLogging == true){
                logvalue = 0
            }
            
            self.tdsdk = TorusSwiftDirectSDK(aggregateVerifierType: verifierTypes(rawValue: aggregateVerifierWeb.aggregateVerifierType)!, aggregateVerifierName: aggregateVerifierWeb.verifierIdentifier, subVerifierDetails: [sub], loglevel: BestLogger.Level(rawValue: logvalue)!)
            
            self.tdsdk!.triggerLogin(browserType: .external).done{ data in
                resolve(data)
            }.catch{ err in
                reject("400", "triggerAggregateLogin: ", err)
            }
        }catch let err as NSError {
            print("JSON decode failed: \(err.localizedDescription)")
            reject("400", "triggerAggregateLogin: ", err.localizedDescription)
        }
    }

    @objc public func getTorusKey(_ verifier: String, verifierId verifierId: String, idToken idToken: String, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock){
        if(self.directAuthArgs == nil){
            reject("400", "getTorusKey: ", "Call .initialize first")
        }
        
        do{
            var logvalue: Int = 5
            if(self.directAuthArgs!.enableLogging != nil && self.directAuthArgs!.enableLogging == true){
                logvalue = 0
            }

            self.tdsdk = TorusSwiftDirectSDK(aggregateVerifierType: .singleLogin, aggregateVerifierName: verifier, subVerifierDetails: [], loglevel: BestLogger.Level(rawValue: logvalue)!)
            self.tdsdk!.getTorusKey(verifier: verifier, verifierId: verifierId, idToken: idToken).done{ data in
                resolve(data)
            }.catch{ err in
                reject("400", "getTorusKey: ", err)
            }
        }catch let err as NSError {
            print("JSON decode failed: \(err.localizedDescription)")
            reject("400", "getTorusKey: ", err.localizedDescription)
        }
    }

    @objc public func getAggregateTorusKey(_ verifier: String, verifierId verifierId: String, idToken idToken: String, subVerifierId subVerifierId: String, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock){
        if(self.directAuthArgs == nil){
            reject("400", "getAggregateTorusKey: ", "Call .initialize first")
        }
        
        do{
            var logvalue: Int = 5
            if(self.directAuthArgs!.enableLogging != nil && self.directAuthArgs!.enableLogging == true){
                logvalue = 0
            }

            let sub = SubVerifierDetails(loginType: .installed,
                                         loginProvider: .jwt,
                                         clientId: "",
                                         verifierName: subVerifierId,
                                         redirectURL: self.directAuthArgs!.redirectUri,
                                         browserRedirectURL: self.directAuthArgs!.browserRedirectUri,
                                         extraQueryParams: [:],
                                         jwtParams: [:])

            self.tdsdk = TorusSwiftDirectSDK(aggregateVerifierType: .singleLogin, aggregateVerifierName: verifier, subVerifierDetails: [sub], loglevel: BestLogger.Level(rawValue: logvalue)!)
            self.tdsdk!.getAggregateTorusKey(verifier: verifier, verifierId: verifierId, idToken: idToken, subVerifierDetails: sub).done{ data in
                resolve(data)
            }.catch{ err in
                reject("400", "getAggregateTorusKey: ", err)
            }
        }catch let err as NSError {
            print("JSON decode failed: \(err.localizedDescription)")
            reject("400", "getAggregateTorusKey: ", err.localizedDescription)
        }
    }
    
    @objc class public func handle(_ url: String){
        TorusSwiftDirectSDK.handle(url: URL(string: url)!)
    }
    
    @objc
    static func requiresMainQueueSetup() -> Bool {
        return true
    }
}

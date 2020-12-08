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
import React

@available(iOS 11.0, *)
@objc(RNTorusDirectSdk)
public class RNTorusDirectSdk: NSObject {
    var tdsdk: TorusSwiftDirectSDK?
    var directAuthVariables: DirectWebSDKArgs?
    var sub: [SubVerifierDetailsWebSDK] = []
    
    @objc public func initialize(_ params: [String: Any]){
        self.directAuthVariables = try? JSONDecoder().decode(DirectWebSDKArgs.self, from: JSONSerialization.data(withJSONObject: params))
    }
    
    @objc public func triggerLogin(_ params: [String:Any], resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock){
        let subverifierWeb = try! JSONDecoder().decode(SubVerifierDetailsWebSDK.self, from: JSONSerialization.data(withJSONObject: params))
        
        let sub = SubVerifierDetails(loginType: SubVerifierType(rawValue: subverifierWeb.webOrInstalled!)!,
                                     loginProvider: LoginProviders(rawValue: subverifierWeb.typeOfLogin)!,
                                     clientId: subverifierWeb.clientId,
                                     verifierName: subverifierWeb.verifier,
                                     redirectURL: directAuthVariables!.redirectUri,
                                     extraQueryParams: subverifierWeb.queryParameters ?? [:],
                                     jwtParams: subverifierWeb.jwtParams ?? [:])
        
        self.tdsdk = TorusSwiftDirectSDK(aggregateVerifierType: .singleLogin, aggregateVerifierName: subverifierWeb.verifier, subVerifierDetails: [sub], loglevel: BestLogger.Level(rawValue: directAuthVariables!.enableLogging!)!)
        
        self.tdsdk!.triggerLogin(browserType: .external).done{ data in
            resolve(data)
        }.catch{ err in
            print(err)
            reject("400", "triggerLogin: ", err)
        }
    }
    
    @objc public func triggerAggregateLogin(_ params: [String:Any], resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock){
        let aggregateVerifierWeb = try! JSONDecoder().decode(AggregateLoginParamsWebSDK.self, from: JSONSerialization.data(withJSONObject: params))
        let subverifierWeb = aggregateVerifierWeb.subVerifierDetailsArray[0]
        
        let sub = SubVerifierDetails(loginType: SubVerifierType(rawValue: subverifierWeb.webOrInstalled!)!,
                                     loginProvider: LoginProviders(rawValue: subverifierWeb.typeOfLogin)!,
                                     clientId: subverifierWeb.clientId,
                                     verifierName: subverifierWeb.verifier,
                                     redirectURL: directAuthVariables!.redirectUri,
                                     extraQueryParams: subverifierWeb.queryParameters ?? [:],
                                     jwtParams: subverifierWeb.jwtParams ?? [:])
        
        self.tdsdk = TorusSwiftDirectSDK(aggregateVerifierType: verifierTypes(rawValue: aggregateVerifierWeb.aggregateVerifierType)!, aggregateVerifierName: aggregateVerifierWeb.verifierIdentifier, subVerifierDetails: [sub], loglevel: BestLogger.Level(rawValue: directAuthVariables!.enableLogging!)!)
        
        self.tdsdk!.triggerLogin(browserType: .external).done{ data in
            resolve(data)
        }.catch{ err in
            print(err)
            reject("400", "triggerAggregateLogin: ", err)
        }
    }
    
    @objc class func handle(_ url: String){
        TorusSwiftDirectSDK.handle(url: URL(string: url)!)
    }
    
    @objc
    static func requiresMainQueueSetup() -> Bool {
        return true
    }
}

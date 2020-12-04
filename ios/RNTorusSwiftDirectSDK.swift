//
//  test1.swift
//  test1
//
//  Created by Shubham on 1/12/20.
//

import Foundation
import TorusSwiftDirectSDK
import PromiseKit
import BestLogger

@objc(RNSubVerifierDetails)
public class RNSubVerifierDetails: NSObject{
  var sub: [SubVerifierDetails] = []
  
  @objc public func init2(_ loginType: String = "web", loginProvider: String, clientId: String, verifierName subverifierId: String, redirectURL: String, extraQueryParams: [String:String] = [:], jwtParams: [String:String] = [:]){
    var tempLoginType: SubVerifierType = .web
    let tempLoginProvider: LoginProviders = LoginProviders(rawValue: loginProvider)!
    
    if(loginType == "web"){
      tempLoginType = .web
    }else if(loginType == "installed"){
      tempLoginType = .installed
    }
    
    self.sub.append(SubVerifierDetails(loginType: tempLoginType, loginProvider: tempLoginProvider, clientId: clientId, verifierName: subverifierId, redirectURL: redirectURL, extraQueryParams: extraQueryParams, jwtParams: jwtParams))
    
  }
  
  func getSub() -> [SubVerifierDetails]{
    return self.sub
  }
  
  @objc static func requiresMainQueueSetup() -> Bool {
    return false
  }
}

@objc(RNTorusSwiftDirectSDK)
public class RNTorusSwiftDirectSDK: NSObject {
  var tdsdk: TorusSwiftDirectSDK?
    
  var sub: [SubVerifierDetails] = []
  
  @objc public func addSubverifier(_ loginType: String = "web", loginProvider: String, clientId: String, subverifierId: String, redirectURL: String, extraQueryParams: [String:String] = [:], jwtParams: [String:String] = [:]){
    var tempLoginType: SubVerifierType = .web
    let tempLoginProvider: LoginProviders = LoginProviders(rawValue: loginProvider)!
    
    if(loginType == "web"){
      tempLoginType = .web
    }else if(loginType == "installed"){
      tempLoginType = .installed
    }
    
    self.sub.append(SubVerifierDetails(loginType: tempLoginType, loginProvider: tempLoginProvider, clientId: clientId, verifierName: subverifierId, redirectURL: redirectURL, extraQueryParams: extraQueryParams, jwtParams: jwtParams))
    
  }
  
  @objc public func init2(_ aggregateVerifierType: String, aggregateVerifierName: String, loglevel: Int = 0){
    let tempAggregateVerifierTypes = verifierTypes(rawValue: aggregateVerifierType)!
    let tempSubs = self.sub
    let tempLogLevel = BestLogger.Level(rawValue: loglevel)!
    
    self.tdsdk = TorusSwiftDirectSDK(aggregateVerifierType: tempAggregateVerifierTypes, aggregateVerifierName: aggregateVerifierName, subVerifierDetails: tempSubs, loglevel: tempLogLevel)
  }
  
  @objc func triggerLogin(_ callback: @escaping RCTResponseSenderBlock){
    self.tdsdk!.triggerLogin(browserType: .external).done{ data in
      print("private key rebuild", data)
      callback([data])
    }.catch{ err in
      print(err)
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

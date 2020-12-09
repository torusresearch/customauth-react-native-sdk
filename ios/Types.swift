//
//  types.swift
//  RNTorusDirectSDK
//
//  Created by Shubham on 8/12/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

struct DirectWebSDKArgs: Codable {
    var redirectUri: String
    var network: String
    var proxyContractAddress: String? = "0x638646503746d5456209e33a2ff5e3226d698bea"
    var enableLogging: Int? = 0
    
    enum CodingKeys: String, CodingKey {
        case redirectUri = "redirectUri"
        case network = "network"
        case proxyContractAddress = "proxyContractAddress"
        case enableLogging = "enableLogging"
    }
    
    init(dictionary: [String: Any]) throws {
        self = try JSONDecoder().decode(DirectWebSDKArgs.self, from: JSONSerialization.data(withJSONObject: dictionary))
    }
    
}

struct SubVerifierDetailsWebSDK: Codable {
    var typeOfLogin: String
    var verifier: String
    var clientId: String
    var jwtParams: [String: String]? = [:]
    var hash: String?;
    var queryParameters: [String: String]? = [:]
    var webOrInstalled: String? = "web"
    
    enum CodingKeys: String, CodingKey {
        case typeOfLogin = "typeOfLogin"
        case verifier = "verifier"
        case clientId = "clientId"
        case jwtParams = "jwtParams"
        case hash = "hash"
        case queryParameters = "queryParameters"
    }
    
    init(dictionary: [String: Any]) throws {
        self = try JSONDecoder().decode(SubVerifierDetailsWebSDK.self, from: JSONSerialization.data(withJSONObject: dictionary))
    }
}

struct AggregateLoginParamsWebSDK: Codable{
    var aggregateVerifierType: String
    var verifierIdentifier: String
    var subVerifierDetailsArray: [SubVerifierDetailsWebSDK]
}

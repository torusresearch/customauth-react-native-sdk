//
//  types.swift
//  RNCustomAuthSDK
//
//  Created by Shubham on 8/12/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import CustomAuth
import FetchNodeDetails

struct CustomAuthArgs: Codable {
    var network: String
    var redirectUri: String
    var browserRedirectUri: String? = "https://scripts.toruswallet.io/redirect.html"
    var enableLogging: Bool? = true
    
    enum CodingKeys: String, CodingKey {
        case redirectUri = "redirectUri"
        case network = "network"
        case browserRedirectUri = "browserRedirectUri"
        case enableLogging = "enableLogging"
    }
    
    init(dictionary: [String: Any]) throws {
        self = try JSONDecoder().decode(CustomAuthArgs.self, from: JSONSerialization.data(withJSONObject: dictionary))
    }
    
    var nativeNetwork: EthereumNetwork {
        get {
            if network == "testnet" {
                return .ROPSTEN
            }
            return .MAINNET
        }
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

struct TorusSubVerifierInfoWebSDK: Codable {
    var verifier: String
    var idToken: String
}

func decodeTorusSubVerifierInfoWebSDK(obj: [String: Any]) throws -> TorusSubVerifierInfoWebSDK {
    do{
        return try JSONDecoder().decode(TorusSubVerifierInfoWebSDK.self, from: JSONSerialization.data(withJSONObject: obj))
    }catch{
        throw error
    }
}

//
//  types.swift
//  RNCustomAuthSDK
//
//  Created by Shubham on 8/12/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import CustomAuth
import FetchNodeDetails
import Foundation

struct CustomAuthArgs: Codable {
    var network: String
    var redirectUri: String
    var browserRedirectUri: String? = "https://scripts.toruswallet.io/redirect.html"
    var enableLogging: Bool? = true
    var enableOneKey: Bool? = false

    enum CodingKeys: String, CodingKey {
        case redirectUri
        case network
        case browserRedirectUri
        case enableLogging
        case enableOneKey
    }

    init(dictionary: [String: Any]) throws {
        self = try JSONDecoder().decode(CustomAuthArgs.self, from: JSONSerialization.data(withJSONObject: dictionary))
    }

    var nativeNetwork: EthereumNetworkFND {
        if network == "testnet" {
            return .ROPSTEN
        } else if network == "cyan" {
            return .POLYGON
        } else {
            return .MAINNET
        }
    }
}

struct SubVerifierDetailsWebSDK: Codable {
    var typeOfLogin: String
    var verifier: String
    var clientId: String
    var jwtParams: [String: String]? = [:]
    var queryParameters: [String: String]? = [:]
    var webOrInstalled: String? = "web"
    var browserType:String? = URLOpenerTypes.asWebAuthSession.rawValue

    enum CodingKeys: String, CodingKey {
        case typeOfLogin
        case verifier
        case clientId
        case jwtParams
        case queryParameters
        case webOrInstalled
        case browserType
    }

    init(dictionary: [String: Any]) throws {
        self = try JSONDecoder().decode(SubVerifierDetailsWebSDK.self, from: JSONSerialization.data(withJSONObject: dictionary))
    }
}

struct AggregateLoginParamsWebSDK: Codable {
    var aggregateVerifierType: String
    var verifierIdentifier: String
    var subVerifierDetailsArray: [SubVerifierDetailsWebSDK]
}

struct TorusSubVerifierInfoWebSDK: Codable {
    var verifier: String
    var idToken: String
}

func decodeTorusSubVerifierInfoWebSDK(obj: [String: Any]) throws -> TorusSubVerifierInfoWebSDK {
    do {
        return try JSONDecoder().decode(TorusSubVerifierInfoWebSDK.self, from: JSONSerialization.data(withJSONObject: obj))
    } catch {
        throw error
    }
}

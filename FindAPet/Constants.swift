//
//  Constants.swift
//  FindAPet
//
//  Created by Leah Doskoez on 2/2/21.
//

import Foundation


struct K {
    
    static let bodyString = "grant_type=client_credentials&client_id=" + Credential.clientID + "&client_secret=" + Credential.clientSecret
    
    static let urlString: (token: String, request: String) = (
        "https://api.petfinder.com/v2/oauth2/token",
        "https://api.petfinder.com/v2/animals?sort=distance&location="
    )
    static let bearer = "Bearer "
}

struct Error {
    static let invalidURL  = "Invalid URL"
    static let invalidBody = "Invalid body"
    static let noData      = "No data"
    static let noToken     = "🚧 No token received. Verify credentials in API-Keys.swift."
}

struct Warning {
    static let testDataUsed = "🚧 Caution. This app is using TEST data."
}

enum HttpMethod: String {
    case post = "POST"
    case get = "GET"
}

enum HttpHeaderField: String {
    case auth = "Authorization"
}

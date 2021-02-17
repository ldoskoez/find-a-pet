//
//  Token.swift
//  FindAPet
//
//  Created by Leah Doskoez on 2/2/21.
//

import Foundation

struct Token: Decodable {
    let tokenType: String?
    let expiresIn: Int?
    let accessToken: String?

    enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case accessToken = "access_token"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        tokenType = try values.decodeIfPresent(String.self, forKey: .tokenType)
        expiresIn = try values.decodeIfPresent(Int.self, forKey: .expiresIn)
        accessToken = try values.decodeIfPresent(String.self, forKey: .accessToken)
    }
}

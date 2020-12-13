//
//  Breeds.swift
//  FindAPet
//
//  Created by Leah Doskoez on 12/11/20.
//

import Foundation

struct Breeds: Codable {
    var primary: String?
    var secondary: String?
    var mixed, unknown: Bool?
}

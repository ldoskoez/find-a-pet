//
//  Animal.swift
//  FindAPet
//
//  Created by Leah Doskoez on 12/11/20.
//

import Foundation

struct Animal: Codable {
    let id: Int?
    let type: String?
    let name: String?
    let gender: String?
    let age: String?
    let primary_photo_cropped: PrimaryPhotoCropped?
    let breeds: Breeds?
}

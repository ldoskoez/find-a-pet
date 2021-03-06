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
    let organization_id: String?
    let breeds: Breeds?
    let colors: Colors?
    let name: String?
    let gender: String?
    let age: String?
    let url: String?
    let environment: Environment?
    let description: String?
    let size: String?
    let coat: String?
    let photos: [Photos]?
    let primary_photo_cropped: PrimaryPhotoCropped?
    let contact: Contact?
}

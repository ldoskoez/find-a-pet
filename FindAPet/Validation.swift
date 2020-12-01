//
//  Validation.swift
//  FindAPet
//
//  Created by Leah Doskoez on 11/30/20.
//

import Foundation

class Validation {

    public func validaPhoneNumber(input: String?) -> Bool {
        guard let input = input else { return false }

        return NSPredicate(format: "SELF MATCHES %@", "^\\d{5}(?:[-\\s]?\\d{4})?$")
            .evaluate(with: input.uppercased())
    }
}

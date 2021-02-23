//
//  fetchHardAnimals.swift
//  FindAPet
//
//  Created by Leah Doskoez on 2/19/21.
//

import Foundation

func readLocalFile(forName name: String) -> Data? {
    do {
        if let bundlePath = Bundle.main.path(forResource: name,
                                             ofType: "json"),
           let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
            return jsonData
        }
    } catch {
        print(error)
    }
    
    return nil
}

func parse(jsonData: Data) -> AnimalsResponse? {
        do {
            let animalsResponse = try JSONDecoder().decode(AnimalsResponse.self,
            from: jsonData) as AnimalsResponse

            return animalsResponse
        } catch {
            print("decode error")
        }
        return nil
    }




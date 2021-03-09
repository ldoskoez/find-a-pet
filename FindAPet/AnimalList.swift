//
//  AnimalList.swift
//  FindAPet
//
//  Created by Leah Doskoez on 2/2/21.
//

import Foundation

protocol AnimalInfo {
    func displayAnimalInfo()
}

class AnimalList{
    var delegate : AnimalInfo?
    var animals : Animal? = nil
    var dispatchGroup = DispatchGroup()
    
    func fetchAnimals(zipcode: String, finished: @escaping (AnimalsResponse?)->Void) {
        guard let url = URL(string: K.urlString.token) else{
            print(Error.invalidURL);
            finished(nil)
            return
        }
        guard let body = K.bodyString.data(using: .utf8) else{
            print(Error.invalidBody);
            finished(nil)
            return
        }
        
        //create token URL request
        var urlRequest = URLRequest(url : url)
        urlRequest.httpMethod = HttpMethod.post.rawValue
        urlRequest.httpBody = body
        
        var accessToken : String? = nil
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            do {
                guard error == nil else { print(error!.localizedDescription); return }
                guard let data = data else { print(Error.noData); return }
                let jsonDecoder = JSONDecoder()
                let token: Token? = try jsonDecoder.decode(Token.self, from: data)
                accessToken = token?.accessToken
                if token == nil { print(Error.noToken) }
                NetworkManager.accessToken = accessToken
                
                guard let url = URL(string: K.urlString.searchrequest + zipcode) else{
                    print(Error.invalidURL);
                    return
                }
                
                //Create data URLRequest using token
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = HttpMethod.get.rawValue
                let value = K.bearer + (NetworkManager.accessToken ?? Error.noToken)
                urlRequest.addValue(value, forHTTPHeaderField: HttpHeaderField.auth.rawValue)
                
                URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                    do {
                        guard error == nil else { print(error?.localizedDescription as Any); return }
                        guard let data = data else { print(Error.noData); return }
                        let jsonDecoder = JSONDecoder()
                        let animalsResponse = try jsonDecoder.decode(AnimalsResponse.self, from: data)
                        finished(animalsResponse)
                    } catch {
                        print(error.localizedDescription)
                    }
                }.resume()
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

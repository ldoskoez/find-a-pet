//
//  SearchViewController.swift
//  FindAPet
//
//  Created by Leah Doskoez on 11/21/20.
//

import UIKit

class PetTableViewCell: UITableViewCell {
    @IBOutlet weak var petPic: UIImageView!
    @IBOutlet weak var petAge: UILabel!
    @IBOutlet weak var petName: UILabel!
    
    
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    //struct definitions
    struct AnimalsResponse : Codable{
        let animals: [Animal]?
    }
    
    struct Animal: Codable {
        let id: Int?
        let type: String?
        let name: String?
        let gender: String?
    }
    
    
    //declarations
    var finalZipcode = ""
    @IBOutlet weak var ZipcodeLabel: UILabel!
    @IBOutlet weak var SearchTable: UITableView!
    var fetchedAnimals : [Animal]!
    
    //Loads the zipcode search
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SearchTable.delegate = self
        SearchTable.dataSource = self
        ZipcodeLabel.text = "Searching for pets in the zipcode: \(finalZipcode)"
        
        //fetchPostData(completionHandler: processPostData(posts:))
        //Fetches data from json file to parse into readable animals for adoption
        fetchedAnimals = parse(jsonData: readLocalFile(forName: "pets_60614")!)?.animals
    }
    
    
    private func readLocalFile(forName name: String) -> Data? {
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
    
    private func parse(jsonData: Data) -> AnimalsResponse? {
        do {
            let animalsResponse = try JSONDecoder().decode(AnimalsResponse.self,
            from: jsonData) as AnimalsResponse
            
//            print("Animal ID: ", animalsResponse.animals?[0].id ?? "None")
//            print("Animal Name:  ", animalsResponse.animals?[0].name ?? "None")
            
            return animalsResponse
        } catch {
            print("decode error")
        }
        return nil
    }
    
    
    //UI Table View functions to determine the number of rows and the content of the cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {           return fetchedAnimals.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PetTableViewCell
        let currentAnimal = fetchedAnimals[indexPath.row]
        cell.petName?.text = currentAnimal.name
        cell.petAge?.text = "\(currentAnimal.gender ?? "") \(currentAnimal.type ?? "")"
//        cell.petPic?.image = UIImage(named: "catdog")
      
//        cell.contentConfiguration = content

        return cell
    }
    
    
}

//extension SearchViewController : UITableViewDelegate{
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("hi boo")
//    }
//}
//



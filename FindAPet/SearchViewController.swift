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
    @IBOutlet weak var petBreed: UILabel!
    
    
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
        let age: String?
        let primary_photo_cropped: PrimaryPhotoCropped?
        let breeds: Breeds?
    }
    
    struct PrimaryPhotoCropped: Codable {
        var small, medium, large, full: String?
    }
    
    struct Breeds: Codable {
        var primary: String?
        var secondary: String?
        var mixed, unknown: Bool?
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
            
            return animalsResponse
        } catch {
            print("decode error")
        }
        return nil
    }
    
    
    //UI Table View functions to determine the number of rows and the content of the cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {           return fetchedAnimals.count
    }
    
    //Gets and sets contents of the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PetTableViewCell
        let currentAnimal = fetchedAnimals[indexPath.row]
        cell.petName?.text = currentAnimal.name
        cell.petAge?.text = "\(currentAnimal.age ?? "") \(currentAnimal.gender ?? "")"
        cell.petBreed?.text = "\(currentAnimal.breeds?.primary ?? "") \(currentAnimal.type ?? "")"
        
        let mediumPic = currentAnimal.primary_photo_cropped?.medium
        if (mediumPic != nil){
            let url = NSURL(string: mediumPic!)
            let data = NSData(contentsOf : url! as URL)
            let image = UIImage(data : data! as Data)
            cell.petPic?.image = image
        }else{
            cell.petPic?.image = UIImage(named: "catdog")
        }
        
        return cell
    }
    
    //function that is called when a cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAnimal=fetchedAnimals[indexPath.row]
        if let vc = storyboard?.instantiateViewController(identifier: "PetViewController") as? PetViewController{
            vc.finalName = selectedAnimal.name ?? ""
            vc.finalBreed = selectedAnimal.breeds?.primary ?? ""
            vc.finalAge = selectedAnimal.age ?? ""
            vc.finalPhoto = selectedAnimal.primary_photo_cropped?.medium ?? ""
            vc.finalGender = selectedAnimal.gender ?? ""
            vc.finalType = selectedAnimal.type ?? ""
            }

        performSegue(withIdentifier: "selectPet", sender: self)


    }
    
    
}








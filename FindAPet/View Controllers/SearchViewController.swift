//
//  SearchViewController.swift
//  FindAPet
//
//  Created by Leah Doskoez on 11/21/20.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    //declarations
    var finalZipcode = ""
    @IBOutlet weak var ZipcodeLabel: UILabel!
    @IBOutlet weak var SearchTable: UITableView!
    var fetchedAnimals : [Animal]!
    let animalList = AnimalList()
    
    //Loads the zipcode search
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SearchTable.delegate = self
        SearchTable.dataSource = self
        
        //hard fetched animals
//        self.fetchedAnimals = parse(jsonData: readLocalFile(forName: "pets_60614")!)?.animals
        
        animalList.fetchAnimals(zipcode: finalZipcode){ animalsResponse in
            self.fetchedAnimals = animalsResponse?.animals
            DispatchQueue.main.async {
                self.SearchTable.reloadData()
            }

        }
        ZipcodeLabel.text = "Displaying pets in: \(finalZipcode)"
        
        SearchTable.rowHeight = UITableView.automaticDimension
        SearchTable.estimatedRowHeight = 600
    }
    
    //UI Table View functions to determine the number of rows and the content of the cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {           return fetchedAnimals?.count ?? 0
    }
    
    //Gets and sets contents of the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PetCell
        let currentAnimal = fetchedAnimals[indexPath.row]
        if (currentAnimal.name != nil){
            cell.petName?.text = currentAnimal.name
        }
        else{
            cell.petName?.text = "Unknown Name"
        }
        if (currentAnimal.age != nil){
            cell.petAge?.text = "\(currentAnimal.age ?? "") \(currentAnimal.gender ?? "")"
        }
        else{
            cell.petAge?.text = "Unknown Age"
        }
        if (currentAnimal.breeds?.primary != nil){
            cell.petBreed?.text = "\(currentAnimal.breeds?.primary ?? "") \(currentAnimal.type ?? "")"
        }
        else{
            cell.petBreed?.text = "Unknown Breed"
        }
        
        
        if ((currentAnimal.photos?.count) != 0){
            let mediumPic = currentAnimal.photos?[0].large
            if (mediumPic != nil){
                let url = NSURL(string: mediumPic!)
                let data = NSData(contentsOf : url! as URL)
                let image = UIImage(data : data! as Data)
                cell.petPic?.image = image
            } else{
                cell.petPic?.image = UIImage(named: "catdog")
            }
        } else{
            cell.petPic?.image = UIImage(named: "catdog")
        }
        return cell
    }
    
    //function that is called when a cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "selectPet", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectPet" ,
           let vc = segue.destination as? PetViewController ,
           let indexPath = self.SearchTable.indexPathForSelectedRow {
            let selectedAnimal = fetchedAnimals[indexPath.row]
            vc.finalAnimal = selectedAnimal
        }
    }
}




//
//  PetViewController.swift
//  FindAPet
//
//  Created by Leah Doskoez on 12/11/20.
//

import UIKit

class PetViewController: UIViewController {
    
    var finalAnimal: Animal?
    @IBOutlet weak var petName: UILabel!
    @IBOutlet weak var petAge: UILabel!
    @IBOutlet weak var petBreed: UILabel!
    @IBOutlet weak var petPic: UIImageView!
    
    //Pets relationship with other beings
    @IBOutlet weak var petGKids: UILabel!
    @IBOutlet weak var petGDog: UILabel!
    @IBOutlet weak var petGCat: UILabel!
    
    
    //buttons
    //email
    @IBAction func learnMore(_ sender: Any) {
        if let url = NSURL(string: (finalAnimal?.url)!){
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    
    //call
    @IBAction func adoptMe(_ sender: Any) {
        print((finalAnimal?.contact?.phone)!)
        guard let url = URL(string: "tel://" + (finalAnimal?.contact?.phone)!) else{ return}
        UIApplication.shared.canOpenURL(url)
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    @IBAction func findMe(_ sender: Any) {
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        petName?.text = finalAnimal?.name
        petAge?.text = "\(finalAnimal?.age ?? "Unknown") \(finalAnimal?.gender ?? "Unknown")"
        petBreed?.text = "\(finalAnimal?.breeds?.primary ?? "Unknown") \(finalAnimal?.type ?? "Unknowns")"
        
        if(finalAnimal?.environment?.children == false){
            petGKids?.text = "Children: No"
        } else if(finalAnimal?.environment?.children == true){
            petGKids?.text = "Children: Yes"
        } else{
            petGKids?.text = "Children: Unknown"
        }
        
        if(finalAnimal?.environment?.cats == false){
            petGCat?.text = "Cats: No"
        } else if(finalAnimal?.environment?.cats == true){
            petGCat?.text = "Cats: Yes"
        } else{
            petGCat?.text = "Cats: Unknown"
        }
        
        if(finalAnimal?.environment?.dogs == false){
            petGDog?.text = "Dogs: No"
        } else if (finalAnimal?.environment?.dogs == true){
            petGDog?.text = "Dogs: Yes"
        } else{
            petGDog?.text = "Dogs: Unknown"
        }
        
        

        let url = NSURL(string: (finalAnimal?.primary_photo_cropped?.medium)!)
        let data = NSData(contentsOf : url! as URL)
        let image = UIImage(data : data! as Data)
        petPic?.image = image
    }
    


    
    

}

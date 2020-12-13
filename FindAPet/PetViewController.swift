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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        petName?.text = finalAnimal?.name
        petAge?.text = "\(finalAnimal?.age ?? "Unknown") \(finalAnimal?.gender ?? "Unknown")"
        petBreed?.text = "\(finalAnimal?.breeds?.primary ?? "Unknown") \(finalAnimal?.type ?? "Unknowns")"

        let url = NSURL(string: (finalAnimal?.primary_photo_cropped?.medium)!)
        let data = NSData(contentsOf : url! as URL)
        let image = UIImage(data : data! as Data)
        petPic?.image = image
    }
    


    
    

}

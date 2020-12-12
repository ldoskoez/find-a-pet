//
//  PetViewController.swift
//  FindAPet
//
//  Created by Leah Doskoez on 12/11/20.
//

import UIKit

class PetViewController: UIViewController {

    var finalName = ""
    var finalBreed = ""
    var finalAge = ""
    var finalGender = ""
    var finalPhoto = ""
    var finalType = ""

    @IBOutlet weak var petName: UILabel!
    @IBOutlet weak var petAge: UILabel!
    @IBOutlet weak var petBreed: UILabel!
    @IBOutlet weak var petPic: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        petName?.text = finalName
        petAge?.text = "\(finalAge) \(finalGender)"
        petBreed?.text = "\(finalBreed) \(finalType)"

        let url = NSURL(string: finalPhoto)
        let data = NSData(contentsOf : url! as URL)
        let image = UIImage(data : data! as Data)
        petPic?.image = image
    }


    
    

}

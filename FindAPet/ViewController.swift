//
//  ViewController.swift
//  FindAPet
//
//  Created by Leah Doskoez on 11/21/20.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var ZipcodeField: UITextField!
    @IBOutlet weak var ErrorMessage: UILabel!
    var validation = Validation()
    var zipcodeText = ""
    

    
    //Makes the num keyboard disappear after touch on screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ZipcodeField.resignFirstResponder()
    }
    
    @IBAction func Search(_ sender: Any) {
        guard let zip = ZipcodeField.text else {
                 return
              }
        
        let isValidateZip = self.validation.validaPhoneNumber(input: zip)
        if (isValidateZip == false) {
            ErrorMessage.text = "Please Enter a Valid Zipcode."
           return
        }
        self.zipcodeText = ZipcodeField.text ?? ""
        performSegue(withIdentifier: "search", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! SearchViewController
        vc.finalZipcode = self.zipcodeText
    }
}

//Extension used to make the text keyboard disappear after pressing return
extension ViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}


//
//  PetViewController.swift
//  FindAPet
//
//  Created by Leah Doskoez on 12/11/20.
//

import UIKit
import CoreLocation
import MapKit
import MessageUI

class PetViewController: UIViewController, MFMailComposeViewControllerDelegate{
    
    var finalAnimal: Animal?
    var str = ""
    @IBOutlet weak var petName: UILabel!
    @IBOutlet weak var petAge: UILabel!
    @IBOutlet weak var petBreed: UILabel!
    @IBOutlet weak var petPic: UIImageView!
    
    //Pets relationship with other beings
    @IBOutlet weak var petGKids: UILabel!
    @IBOutlet weak var petGDog: UILabel!
    @IBOutlet weak var petGCat: UILabel!
    
    var fetchedOrg : Organization?
    
    //buttons
    //opens petfinder web
//    @IBAction func learnMore(_ sender: Any) {
//        if let url = NSURL(string: (finalAnimal?.url)!){
//            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
//        }
//    }
    
    @IBAction func learnMore(_ sender: Any) {
        
        let recipientEmail = self.fetchedOrg?.email ?? "" + ""
        let subject = "Interested in " + (finalAnimal?.name)!
        let body = "Hello! I would like to know more information about an animal at your shelter."
            
            // Show default mail composer
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipientEmail])
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: false)
            
            present(mail, animated: true)
        
        // Show third party email composer if default Mail app is not present
        } else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
            UIApplication.shared.open(emailUrl)
        }
        }
        
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }
        
        return defaultUrl
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    

    
    //call
    @IBAction func adoptMe(_ sender: Any) {
//        print((finalAnimal?.contact?.phone)!)
//        if (finalAnimal?.contact?.phone == nil){
//            let alert = UIAlertController(title: "Error", message: "Phone Number Cannot Be Found", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                switch action.style{
//                    case .default:
//                    print("default")
//
//                    case .cancel:
//                    print("cancel")
//
//                    case .destructive:
//                    print("destructive")
//
//                }
//            }))
//            self.present(alert, animated: true, completion: nil)
//        }
        let trimmedPhone = finalAnimal?.contact?.phone?.replacingOccurrences(of: ")", with: "")
        let trimmedPhone2 = trimmedPhone?.replacingOccurrences(of: "(", with: "")
        let trimmedPhone3 = trimmedPhone2!.replacingOccurrences(of: "-", with: "")
        let trimmedPhone4 = trimmedPhone3.replacingOccurrences(of: " ", with: "")

        guard let url = URL(string: "tel://" + trimmedPhone4) else{ return}
        UIApplication.shared.canOpenURL(url)
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
    //map
    @IBAction func findMe(_ sender: Any) {
        let geocoder = CLGeocoder()
        let finalAddr = finalAnimal?.contact?.address
        if (finalAddr?.address1 != nil){
            str = (finalAddr?.address1)! + " " + (finalAddr?.city)!
        }
        else if (finalAddr?.city != nil){
            str = (finalAddr?.city)! + " " + (finalAddr?.state)!
        }
        else{
            let alert = UIAlertController(title: "Error", message: "Address Cannot Be Found", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                    case .default:
                    print("default")
                    
                    case .cancel:
                    print("cancel")
                    
                    case .destructive:
                    print("destructive")
                    
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        
        geocoder.geocodeAddressString(str) { (placemarksOptional, error) -> Void in
          if let placemarks = placemarksOptional {

            if let location = placemarks.first?.location {
                let latitude: CLLocationDegrees = location.coordinate.latitude
                let longitude: CLLocationDegrees = location.coordinate.longitude

                let regionDistance:CLLocationDistance = 10000
                let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
                let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
                let options = [
                    MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                    MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
                ]
                let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
                let mapItem = MKMapItem(placemark: placemark)
                if (self.fetchedOrg?.name != nil){
                    mapItem.name = self.fetchedOrg?.name
                }
                else{
                    mapItem.name = "Unknown Name"
                }
                mapItem.openInMaps(launchOptions: options)
              } else {
                // Could not construct url. Handle error.
                let alert = UIAlertController(title: "Error", message: "Map Cannot Be Launched", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                        case .default:
                        print("default")
                        
                        case .cancel:
                        print("cancel")
                        
                        case .destructive:
                        print("destructive")
                        
                    }
                }))
                self.present(alert, animated: true, completion: nil)
                
              }
            } else {
              // Could not get a location from the geocode request. Handle error.
                let alert = UIAlertController(title: "Error", message: "Address Cannot Be Found", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                        case .default:
                        print("default")
                        
                        case .cancel:
                        print("cancel")
                        
                        case .destructive:
                        print("destructive")
                        
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            }
          
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: K.urlString.orgrequest + (finalAnimal?.organization_id)!) else{
            return
        }
        
        //Create data URLRequest using token
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HttpMethod.get.rawValue
        let value = K.bearer + (NetworkManager.accessToken ?? Error.noToken)
//        print(NetworkManager.accessToken!)
        urlRequest.addValue(value, forHTTPHeaderField: HttpHeaderField.auth.rawValue)
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            do {
                guard error == nil else { print(error?.localizedDescription as Any); return }
                guard let data = data else { print(Error.noData); return }
                let jsonDecoder = JSONDecoder()
                let orgResponse = try jsonDecoder.decode(OrgResponse.self, from: data)
                self.fetchedOrg = orgResponse.organization
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
        
        petName?.text = finalAnimal?.name
        petAge?.text = "\(finalAnimal?.age ?? "Unknown Age") \(finalAnimal?.gender ?? "Unknown Gender")"
        petBreed?.text = "\(finalAnimal?.breeds?.primary ?? "Unknown Breed") \(finalAnimal?.type ?? "Unknown Type")"
        
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

        let picurl = NSURL(string: (finalAnimal?.primary_photo_cropped?.medium) ?? "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/f1257514-4e00-461f-877f-8dd37dfee9ce/dbitvu2-6dd9a4f7-2e94-47a2-a094-e098063ac639.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOiIsImlzcyI6InVybjphcHA6Iiwib2JqIjpbW3sicGF0aCI6IlwvZlwvZjEyNTc1MTQtNGUwMC00NjFmLTg3N2YtOGRkMzdkZmVlOWNlXC9kYml0dnUyLTZkZDlhNGY3LTJlOTQtNDdhMi1hMDk0LWUwOTgwNjNhYzYzOS5wbmcifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6ZmlsZS5kb3dubG9hZCJdfQ.9TYVg6rfyzpa-wI-Ro5T2Mi2uKiqrJM9cShOg8mCHfs")
        let data = NSData(contentsOf : picurl! as URL)
        let image = UIImage(data : data! as Data)
        petPic?.image = image
    }
    
    
    
    
    
    
//    private func readLocalFile(forName name: String) -> Data? {
//        do {
//            if let bundlePath = Bundle.main.path(forResource: name,
//                                                 ofType: "json"),
//                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
//                return jsonData
//            }
//        } catch {
//            print(error)
//        }
//
//        return nil
//    }
//
//    private func parse(jsonData: Data) -> OrgResponse? {
//        do {
//            let orgResponse = try JSONDecoder().decode(OrgResponse.self,
//            from: jsonData) as OrgResponse
//
//            return orgResponse
//        } catch {
//            print("decode error")
//        }
//        return nil
//    }
}

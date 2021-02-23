//
//  PetViewController.swift
//  FindAPet
//
//  Created by Leah Doskoez on 12/11/20.
//

import UIKit
import CoreLocation
import MapKit

class PetViewController: UIViewController {
    
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
    struct OrgResponse : Codable{
        let organization: Organization?
    }
    
    //buttons
    //opens petfinder web
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
    //map
    @IBAction func findMe(_ sender: Any) {
        let geocoder = CLGeocoder()
        let finalAddr = finalAnimal?.contact?.address
        if (finalAddr?.address1 != nil){
            str = (finalAddr?.address1)! + " " + (finalAddr?.city)!
        } else{
            str = (finalAddr?.city)! + " " + (finalAddr?.state)!
        }
        
        
        geocoder.geocodeAddressString(str) { (placemarksOptional, error) -> Void in
          if let placemarks = placemarksOptional {
            print("placemark| \(String(describing: placemarks.first))")
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
                mapItem.name = self.fetchedOrg?.name
                mapItem.openInMaps(launchOptions: options)
              } else {
                // Could not construct url. Handle error.
              }
            } else {
              // Could not get a location from the geocode request. Handle error.
            }
          
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedOrg = parse(jsonData: readLocalFile(forName: "orgIL72")!)?.organization
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

        let url = NSURL(string: (finalAnimal?.primary_photo_cropped?.medium) ?? "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/f1257514-4e00-461f-877f-8dd37dfee9ce/dbitvu2-6dd9a4f7-2e94-47a2-a094-e098063ac639.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOiIsImlzcyI6InVybjphcHA6Iiwib2JqIjpbW3sicGF0aCI6IlwvZlwvZjEyNTc1MTQtNGUwMC00NjFmLTg3N2YtOGRkMzdkZmVlOWNlXC9kYml0dnUyLTZkZDlhNGY3LTJlOTQtNDdhMi1hMDk0LWUwOTgwNjNhYzYzOS5wbmcifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6ZmlsZS5kb3dubG9hZCJdfQ.9TYVg6rfyzpa-wI-Ro5T2Mi2uKiqrJM9cShOg8mCHfs")
        let data = NSData(contentsOf : url! as URL)
        let image = UIImage(data : data! as Data)
        petPic?.image = image
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
    
    private func parse(jsonData: Data) -> OrgResponse? {
        do {
            let orgResponse = try JSONDecoder().decode(OrgResponse.self,
            from: jsonData) as OrgResponse
            
            return orgResponse
        } catch {
            print("decode error")
        }
        return nil
    }
}

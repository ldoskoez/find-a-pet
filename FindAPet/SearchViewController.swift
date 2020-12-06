//
//  SearchViewController.swift
//  FindAPet
//
//  Created by Leah Doskoez on 11/21/20.
//

import UIKit

class PetTableViewCell: UITableViewCell {

    @IBOutlet weak var petName: UILabel!
    @IBOutlet weak var petAge: UILabel!
    @IBOutlet weak var petPic: UIImageView!
    
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    //declarations
    var finalZipcode = ""
    @IBOutlet weak var ZipcodeLabel: UILabel!
    @IBOutlet weak var SearchTable: UITableView!
    var fetchedPosts = [Post]()
    var fetchedAnimals : [Animal]!
    
    //Loads the zipcode search
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SearchTable.delegate = self
        SearchTable.dataSource = self
        
        ZipcodeLabel.text = "Searching for pets in the zipcode: \(finalZipcode)"
        
        //fetchPostData(completionHandler: processPostData(posts:))
        fetchedAnimals = parse(jsonData: readLocalFile(forName: "pets_60614")!)?.animals
    }
    
    func processPostData (posts : [Post] ){
        DispatchQueue.main.async {
            for posts in posts{
                print(posts.title!)
            }
            self.fetchedPosts = posts
            self.SearchTable.reloadData()
        }
    }
    
    //fetch post data and compiles it to data that we can use
    func fetchPostData(completionHandler : @escaping ([Post]) -> Void){
        
        
        let url = URL(string : "https://jsonplaceholder.typicode.com/posts")!
        
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            guard let data = data
            else{
                return
            }
            
            do{
                let postsData = try JSONDecoder().decode([Post].self, from: data)
                completionHandler(postsData)
            }
            
            catch{
                let error = error
                print(error.localizedDescription)
            }
        }.resume()
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
            
            print("Animal ID: ", animalsResponse.animals?[0].id ?? "None")
            print("Animal Name:  ", animalsResponse.animals?[0].name ?? "None")
            
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
      
//        cell.contentConfiguration = content

        return cell
    }
    
    
    //struct and class definitions
    struct AnimalsResponse : Codable{
        let animals: [Animal]?
    }
    
    struct Animal: Codable {
        let id: Int?
        let type: String?
        let name: String?
        let gender: String?
    }

    class Post : Codable{
        var userId : Int!
        var id : Int!
        var title : String!
        var body : String!
    }
    
    
}

//extension SearchViewController : UITableViewDelegate{
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("hi boo")
//    }
//}
//



//
//  SearchViewController.swift
//  FindAPet
//
//  Created by Leah Doskoez on 11/21/20.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
  
    //UI Table View functions to determine the number of rows and the content of the cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {           return fetchedPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        content.text = fetchedPosts[indexPath.row].title
        content.secondaryText = String(fetchedPosts[indexPath.row].userId)
        
        cell.contentConfiguration = content

        return cell
    }
    
    //declarations
    @IBOutlet weak var ZipcodeLabel: UILabel!
    var finalZipcode = ""
    @IBOutlet weak var SearchTable: UITableView!
    var fetchedPosts = [Post]()
    
    
    //Loads the zipcode search
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SearchTable.delegate = self
        SearchTable.dataSource = self
        
        ZipcodeLabel.text = "Searching for pets in the zipcode: \(finalZipcode)"
        
        fetchPostData(completionHandler: processPostData(posts:))
        
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
//extension SearchViewController : UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = "Hello world"
//
//        return cell
//    }
//
//
//}


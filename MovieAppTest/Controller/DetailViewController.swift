//
//  DetailViewController.swift
//  MovieAppTest
//
//  Created by Hannatassja Hardjadinata on 05/10/22.
//

import UIKit
import Alamofire

class DetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        
    }
    
    func register() {
        
    }
    
    func getData(){
        let url = "https://api.themoviedb.org/3/movie/760161?api_key=2ff28843d44ac133274d2352fbcb0ebe&language=en-US"
  
        AF.request(url).response { [self] response in
            guard let data = response.data else {return}
            do {
                let decoder = JSONDecoder()
                let movieData = try decoder.decode(Movie.self, from: data)
                DispatchQueue.main.async {
                    self.movie = movieData
                    self.tableView.reloadData()
                }
            } catch let error {
                print(error)
            }
        }

    }
}

extension UIViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch indexPath.row {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: <#T##IndexPath#>)
        case 2:
        case 3:
        default:
        }
        
        return cell
    }
    
    
}

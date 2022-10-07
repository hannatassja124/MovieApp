//
//  ReviewViewController.swift
//  MovieAppTest
//
//  Created by Hannatassja Hardjadinata on 07/10/22.
//

import UIKit
import Alamofire

class ReviewViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var reviews: [Review] = []
    var id: Int = 0
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "ReviewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Review")
        
        self.getData()
    }
    
    func getData() {
        let url = "https://api.themoviedb.org/3/movie/\(id)/reviews?api_key=2ff28843d44ac133274d2352fbcb0ebe&language=en-US"
        
        AF.request(url).response { [self] response in
            guard let data = response.data else {return}
            do {
                let decoder = JSONDecoder()
                let movieData = try decoder.decode(ReviewList.self, from: data)
                for i in movieData.results {
                    self.reviews.append(i)
                }
                
                DispatchQueue.main.async {
                    print("test123", movieData.results)
                    self.tableView.reloadData()
                }
            } catch let error {
                print(error)
            }
        }
    }
    
}

extension ReviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Review", for: indexPath) as! ReviewCell
        if !reviews.isEmpty {
            cell.usernameLabel.text = reviews[indexPath.row].author
            cell.ratingLabel.text = "\(reviews[indexPath.row].rating)"
            cell.descriptionLabel.text = reviews[indexPath.row].content
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
}

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
    var movie: Movie? = nil
    var id: Int = 0
    var videos: [Trailer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        getVideo()
        tableView.delegate = self
        tableView.dataSource = self
        register()
        
    }
    
    func register() {
        let nibOne = UINib(nibName: "SectionOneCell", bundle: nil)
        let nibTwo = UINib(nibName: "SectionTwoCell", bundle: nil)
        let nibThree = UINib(nibName: "SectionThreeCell", bundle: nil)
        
        self.tableView.register(nibOne, forCellReuseIdentifier: "SectionOne")
        self.tableView.register(nibTwo, forCellReuseIdentifier: "SectionTwo")
        self.tableView.register(nibThree, forCellReuseIdentifier: "SectionThree")
    }
    
    func getVideo() {
        let url = "https://api.themoviedb.org/3/movie/\(id)/videos?api_key=2ff28843d44ac133274d2352fbcb0ebe&language=en-US"
        AF.request(url).response { [self] response in
            guard let data = response.data else {return}
            do {
                let decoder = JSONDecoder()
                let movieData = try decoder.decode(TrailerList.self, from: data)
                self.videos = movieData.results.filter{$0.type == "Trailer"}
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    func getData(){
        let url = "https://api.themoviedb.org/3/movie/\(id)?api_key=2ff28843d44ac133274d2352fbcb0ebe&language=en-US"
  
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
    
    func movePage(){
        let storyboard = UIStoryboard(name: "Review", bundle: nil)
        
        let reviewVC = storyboard.instantiateViewController(withIdentifier: "ReviewStoryboard") as! ReviewViewController
        reviewVC.navigationItem.title = "Reviews"
        reviewVC.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(dismissPage(sender:)))
        if let id = movie?.id {
            reviewVC.id = id
        }
        
        let nav = UINavigationController(rootViewController: reviewVC)
        
        self.present(nav, animated: true)
    }
    
    @objc func dismissPage(sender: UIBarButtonItem){
        dismiss(animated: true, completion: nil)
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionOne", for: indexPath) as! SectionOneCell
            if let data = movie {
                cell.titleLabel.text = data.title
                cell.durationLabel.text = "\(data.duration ?? 0) menit"
                cell.descriptionLabel.text = data.description
                cell.posterImageView.contentMode = .scaleAspectFill
                cell.posterImageView.downloadImage(from: URL(string: "https://image.tmdb.org/t/p/w500\(data.poster)")!)
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionTwo", for: indexPath) as! SectionTwoCell
            if !videos.isEmpty {
                cell.playerView.load(withVideoId: videos[0].key)
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionThree", for: indexPath) as! SectionThreeCell
            if let data = movie {
                cell.ratingLabel.text = String(format: "%.2f/10", data.rating)
                cell.onButtonTapped = {
                    self.movePage()
                }
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionOne", for: indexPath) as! SectionOneCell
            return cell
        }
    }
    
    
}

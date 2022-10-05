//
//  ViewController.swift
//  MovieAppTest
//
//  Created by Hannatassja Hardjadinata on 04/10/22.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        collectionView.dataSource = self
        collectionView.delegate = self

        let nib = UINib(nibName: "CustomCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "customCell")
    }
    
    func getData(){
        let url = "https://api.themoviedb.org/3/discover/movie?api_key=2ff28843d44ac133274d2352fbcb0ebe&language=en-US&sort_by=popularity.desc&page=1"
  
        AF.request(url).response { [self] response in
            guard let data = response.data else {return}
            do {
                let decoder = JSONDecoder()
                let listData = try decoder.decode(List.self, from: data)
                DispatchQueue.main.async {
                    for data in listData.results {
                        self.movies.append(data)
                    }
                    self.collectionView.reloadData()
                }
            } catch let error {
                print(error)
            }
        }

    }

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
        if !movies.isEmpty {
            cell.movie = movies[indexPath.row]
        }
    
        return cell
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                }
            }
        }
    }
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}

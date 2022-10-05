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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        
        let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailStoryboard") as! DetailViewController
        detailVC.navigationItem.title = "Movies Detail"
        detailVC.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(dismissPage(sender:)))
        
        let nav = UINavigationController(rootViewController: detailVC)
        nav.modalPresentationStyle = .fullScreen
        
        self.present(nav, animated: true)
    }
    
    @objc func dismissPage(sender: UIBarButtonItem){
        dismiss(animated: true, completion: nil)
    }
}

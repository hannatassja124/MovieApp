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
    private var currentPage: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData(page: currentPage)
        collectionView.dataSource = self
        collectionView.delegate = self

        let nib = UINib(nibName: "CustomCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "customCell")
    }
    
    func getData(page: Int){
        let url = "https://api.themoviedb.org/3/discover/movie?api_key=2ff28843d44ac133274d2352fbcb0ebe&language=en-US&sort_by=popularity.desc&page=\(page)"
  
        AF.request(url).response { [self] response in
            guard let data = response.data else {return}
            do {
                collectionView.isHidden = false
                let decoder = JSONDecoder()
                let listData = try decoder.decode(List.self, from: data)
                for data in listData.results {
                    self.movies.append(data)
                }
                DispatchQueue.main.async {
                    self.reloadData(newCount: listData.results.count)
                }
            } catch let error {
                collectionView.isHidden = true
                print(error)
            }
        }

    }
    
    func reloadData(newCount: Int) {
        if currentPage > 1 {
            self.collectionView.performBatchUpdates{
                var indexPath: [IndexPath] = []
                let oldCount = movies.count - 1
                
                
                for i in oldCount - newCount...oldCount{
                    indexPath.append(IndexPath(row: i, section: 0))
                }
                
                self.collectionView.insertItems(at: indexPath)
            }
        } else {
            self.collectionView.reloadData()
        }
    }

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        if indexPath.row == movies.count-3 {
            currentPage += 1
            getData(page: currentPage)
        }
    }
    
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
        detailVC.id = movies[indexPath.row].id
        
        let nav = UINavigationController(rootViewController: detailVC)
        nav.modalPresentationStyle = .fullScreen
        
        self.present(nav, animated: true)
    }
    
    @objc func dismissPage(sender: UIBarButtonItem){
        dismiss(animated: true, completion: nil)
    }
}

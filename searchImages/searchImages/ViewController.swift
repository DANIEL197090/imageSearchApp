//
//  ViewController.swift
//  searchImages
//
//  Created by Decagon on 12/09/2021.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource , UISearchBarDelegate {
  var result = [Result]()
  private var collectionView: UICollectionView?
  let searchBar: UISearchBar = {
    let search  = UISearchBar()
    search.placeholder = "Search for any image"
    return search
  }()
  let urlString = "https://api.unsplash.com/search/photos?page=1&query=office&client_id=nUMhinsXytBbBti499wFV-Lhilkt5DTp5ZAfhIflIOE"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    searchBar.delegate = self
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    layout.itemSize = CGSize(width: view.frame.size.width / 2, height: view.frame.size.width / 2)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    // collectionView.delegate = self
    collectionView.dataSource = self
    view.addSubview(collectionView)
    view.addSubview(searchBar)
    collectionView.backgroundColor = .systemBackground
    self.collectionView = collectionView
    collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
    
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    collectionView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 55, width: view.frame.size.width, height: view.frame.size.height - 55 )
    searchBar.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: view.frame.width - 20, height: 50)
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if let text = searchBar.text {
      result = []
      collectionView?.reloadData()
      fetchData(query: text)
    }
  }
  
  func fetchData(query: String){
    let urlString = "https://api.unsplash.com/search/photos?page=1&query=\(query)&client_id=nUMhinsXytBbBti499wFV-Lhilkt5DTp5ZAfhIflIOE"
    
    guard let url = URL(string: urlString) else {
      return
    }
    let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
      guard let data = data, error == nil else {
        return
      }
      do {
        
        let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data)
        
        DispatchQueue.main.async {
          
          self!.result = jsonResult.results
          self?.collectionView?.reloadData()
        }
      }
      catch {
        print("error")
      }
    }
    
    task.resume()
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return result.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let imageUrlString = result[indexPath.row].urls.regular
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else {
      return UICollectionViewCell()
    }
    //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    cell.configure(with: imageUrlString)
    return cell
  }
  
  
  
}


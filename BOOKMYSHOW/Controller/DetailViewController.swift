//
//  DetailViewController.swift
//  BOOKMYSHOW
//
//  Created by Sanjay Mali on 23/02/19.
//  Copyright © 2019 LoyltyRewardz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    let  api_SimilarMovie = "https://api.themoviedb.org/3/movie/12/similar?api_key=b4ee6d2b12cb6216dad6784010f6af7f"
    let  api_Review = "https://api.themoviedb.org/3/movie/12/reviews?api_key=b4ee6d2b12cb6216dad6784010f6af7f&language=en-US&page=1"
    let  api_Credits = "https://api.themoviedb.org/3/movie/12/credits?api_key=b4ee6d2b12cb6216dad6784010f6af7f"
    let  api_Synopis = ""
    let api = "https://api.themoviedb.org/3/movie/now_playing?api_key=b4ee6d2b12cb6216dad6784010f6af7f&language=en-US&page=1"
    let imageBaseUrl = "https://image.tmdb.org/t/p/w500"

    var results = [MovieListModel]()
    var creditModel = [CreditModel]()

    @IBOutlet weak var collectionView1:UICollectionView!
    @IBOutlet weak var collectionView2:UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
         similarMovies()
         credits()
        self.collectionView1.delegate = self
        self.collectionView1.dataSource = self
        
        self.collectionView2.delegate = self
        self.collectionView2.dataSource = self
        
    }
}

extension DetailViewController{
    func similarMovies(){
        DataManager.init().getRequest(api_SimilarMovie, param:[:]) { (data, error) in
            guard let data = data else { return
            }
            let decoder = JSONDecoder()
            do{
                
                let json = try decoder.decode(BaseModel.self, from: data)
                self.results  = json.results!
                DispatchQueue.main.async {
                    self.collectionView1.reloadData()
                }
            }
            catch{
                print(error.localizedDescription)
            }
            
        }
    }
    func reviews(){
        DataManager.init().webservice(api_Review, param:[:]) { (data, error) in
            guard let data = data else { return
            }
            let decoder = JSONDecoder()
            do{
                
                let json = try decoder.decode(BaseModel.self, from: data)
                self.results  = json.results!
                DispatchQueue.main.async {
//                    self.tableView.reloadData()
                }
            }
            catch{
                print(error.localizedDescription)
            }
            
        }
    }
    
    func credits(){
        DataManager.init().getRequest(api_Credits, param:[:]) { (data,error) in

            guard let data = data else { return
            }
            let decoder = JSONDecoder()
            do{
                let json = try decoder.decode(CreditBaseModel.self, from: data)
                self.creditModel  = json.cast!
                DispatchQueue.main.async {
                    self.collectionView2.reloadData()
                }
            }
            catch{
                print(error.localizedDescription)
            }
            
        }
    }
}

extension DetailViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView1{
        return self.results.count
        }else{
            return self.creditModel.count

        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for:indexPath) as! SimilarMoviesCell
        if collectionView == collectionView1{
            let data = self.results[indexPath.row]

            if data.poster_path != ""{
                let url = URL(string: imageBaseUrl + data.poster_path! )
                cell.bannerImageView.loadImageWithUrl(url!)
            }else{
                cell.bannerImageView.image = UIImage(named:"book")
            }
            cell.movieTitleLbl.text = self.results[indexPath.row].title
            cell.layer.cornerRadius = 15
            cell.layer.borderColor = UIColor.init(red: 141/255, green: 61/255, blue: 104/255, alpha: 1).cgColor
            cell.layer.borderWidth = 1
            cell.layer.masksToBounds = true
        }else if collectionView == collectionView2{
            let data = self.creditModel[indexPath.row]

            if data.profile_path != ""{
                let url = URL(string: imageBaseUrl + data.profile_path! )
                cell.bannerImageView.loadImageWithUrl(url!)
            }else{
                cell.bannerImageView.image = UIImage(named:"book")
            }
            cell.movieTitleLbl.text = self.creditModel[indexPath.row].name
            cell.layer.cornerRadius = 15
            cell.layer.borderColor = UIColor.init(red: 141/255, green: 61/255, blue: 104/255, alpha: 1).cgColor
            cell.layer.borderWidth = 1
            cell.layer.masksToBounds = true
        }
        return cell
        
    }
}
extension DetailViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionView1{

        let layout = self.collectionView1.collectionViewLayout as! UICollectionViewFlowLayout
        let numberOfperRow:CGFloat = 2.0
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing  = 4
        return CGSize(width:collectionView1.bounds.width/2, height:collectionView1.bounds.height)
        }else{
            
            let layout = self.collectionView1.collectionViewLayout as! UICollectionViewFlowLayout
            let numberOfperRow:CGFloat = 2.0
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing  = 4
            return CGSize(width:collectionView2.bounds.width/2, height:collectionView2.bounds.height)
        }
    }
}

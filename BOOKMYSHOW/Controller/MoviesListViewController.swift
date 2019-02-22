//
//  ViewController.swift
//  BOOKMYSHOW
//
//  Created by Sanjay Mali on 22/02/19.
//  Copyright © 2019 LoyltyRewardz. All rights reserved.
//

import UIKit

class MoviesListViewController: UIViewController {
    let api = "https://api.themoviedb.org/3/movie/now_playing?api_key=b4ee6d2b12cb6216dad6784010f6af7f&language=en-US&page=1"
    let imageBaseUrl = "https://image.tmdb.org/t/p/w500"
    @IBOutlet weak var tableView:UITableView!
    var results = [MovieListModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getList()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = 184
    }
    func getList(){
        DataManager.init().webservice(api, param:[:]) { (data, error) in
            guard let data = data else { return
            }
            let decoder = JSONDecoder()
            do{
                
                let json = try decoder.decode(BaseModel.self, from: data)
                self.results  = json.results!
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            catch{
                print(error.localizedDescription)
            }
            
        }
    }
}

extension MoviesListViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for:indexPath) as! MovieCell
        cell.bannerImageView.layer.cornerRadius = cell.bannerImageView.frame.height/2
        cell.bannerImageView.layer.borderColor = UIColor.black.cgColor
        cell.bannerImageView.layer.borderWidth = 1
        cell.bannerImageView.layer.masksToBounds = true
        
        cell.bannerView.layer.cornerRadius = 10
        cell.bannerView.layer.borderColor = UIColor.init(red: 141/255, green: 61/255, blue: 104/255, alpha: 1).cgColor
        cell.bannerView.layer.borderWidth = 2
        cell.bannerView.layer.masksToBounds = true
        
        
        let data = self.results[indexPath.row]
        cell.movieTitleLbl.text = data.title
        cell.releaseDate.text = data.release_date
        if data.poster_path != ""{
            let url = URL(string: imageBaseUrl + data.poster_path! )
          cell.bannerImageView.loadImageWithUrl(url!)
        }else{
            cell.bannerImageView.image = UIImage(named:"book")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.4) {
            cell.transform = CGAffineTransform.identity
        }
    }
}

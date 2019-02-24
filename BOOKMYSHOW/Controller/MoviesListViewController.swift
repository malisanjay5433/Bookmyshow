//
//  ViewController.swift
//  BOOKMYSHOW
//
//  Created by Sanjay Mali on 22/02/19.
//  Copyright © 2019 LoyltyRewardz. All rights reserved.
//

import UIKit
import Foundation
import NaturalLanguage

class MoviesListViewController: UIViewController {
    let api = "https://api.themoviedb.org/3/movie/now_playing?api_key=b4ee6d2b12cb6216dad6784010f6af7f&language=en-US&page=1"
    let imageBaseUrl = "https://image.tmdb.org/t/p/w500"
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var searchText:UITextField!
    
    var results = [MovieListModel]()
    var filter = [MovieListModel]()
    var isSearch:Bool?
    var arrString = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getList()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = 184
        self.searchText.delegate = self
        isSearch = false
        
        let text = "Hello, I'm pretty excited about Natural Language!"
        
        let tokenizer = NLTokenizer(unit: .word)
        tokenizer.setLanguage(.english)
        tokenizer.string = text
        let tokens = tokenizer.tokens(for: text.startIndex..<text.endIndex)
        let a  = "You have typed \(tokens.count) words"
        //        print(a)
        
        
        // Handle each token, (i.e add to array)
    }
    func getList(){
        DataManager.init().webservice(api, param:[:]) { (data, error) in
            guard let data = data else { return
            }
            let decoder = JSONDecoder()
            do{
                
                let json = try decoder.decode(BaseModel.self, from: data)
                self.results  = json.results!
                self.NSToken()
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
extension MoviesListViewController:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch  == false{
            return self.results.count
        }else{
            return self.filter.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for:indexPath) as! MovieCell
        cell.bannerImageView.layer.cornerRadius = cell.bannerImageView.frame.height/2
        cell.bannerImageView.layer.borderColor = UIColor.black.cgColor
        cell.bannerImageView.layer.borderWidth = 1
        cell.bannerImageView.layer.masksToBounds = true
        if isSearch  == false{
            let data = self.results[indexPath.row]
            cell.movieTitleLbl.text = "Movie: \(data.title!)"
            cell.releaseDate.text = "Release on: \(data.release_date!)"
            if data.poster_path != ""{
                let url = URL(string: imageBaseUrl + data.poster_path! )
                cell.bannerImageView.loadImageWithUrl(url!)
            }else{
                cell.bannerImageView.image = UIImage(named:"book")
            }
        }else{
            let data = self.filter[indexPath.row]
            cell.movieTitleLbl.text = "Movie: \(data.title!)"
            cell.releaseDate.text = "Release on: \(data.release_date!)"
            if data.poster_path != ""{
                let url = URL(string: imageBaseUrl + data.poster_path! )
                cell.bannerImageView.loadImageWithUrl(url!)
            }else{
                cell.bannerImageView.image = UIImage(named:"book")
            }
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

extension MoviesListViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Details", sender: nil)
    }
}
extension MoviesListViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //        print(textField.text)
        isSearch = true
        if (textField.text?.count)! > 2{
//            self.filter = results.filter({
//                $0.title!.range(of: textField.text!, options: .regularExpression) != nil
//            })
//            NSToken()
            
            let a = arrString.filter({ (value) -> Bool in
                value.range(of: textField.text!.trimmingCharacters(in:.whitespaces), options: .regularExpression) != nil
            })
            print(a.count)
            for i in a{
                print("Movie Name:\(i)")
                let b = results.filter{(x) -> Bool in
                    x.title!.range(of:i, options: .caseInsensitive) != nil
                }
                self.filter = b
            }
            self.tableView.reloadData()
        }
        return true
    }
    
    func NSToken() {
        for i in results{
            let tagger = NSLinguisticTagger(tagSchemes: [.tokenType], options: 0)
            tagger.string = i.title
            let range = NSRange(location: 0, length: i.title!.utf16.count)
            //Setting various options, such as ignoring white spaces and punctuations
            let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace]
            //We enumerate through the tagger, using the properties set above
            tagger.enumerateTags(in: range, unit: .word, scheme: .tokenType, options: options) { tag, tokenRange, stop in
                let token = (i.title as! NSString).substring(with: tokenRange)
//                print(token)
                arrString.append(token)
            }
        }
    }
//    func tokensationSearch() ->[String]{
//        //        let tagger = NSLinguisticTagger(tagSchemes: [.tokenType, .language, .lexicalClass, .nameType, .lemma], options: 0)
//        //        let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
//        //        let text = "Steve Jobs, Steve Wozniak, and Ronald Wayne founded Apple Inc in California."
//        //        var arr:[MovieListModel]?
//        var arr:[String]?
//
//        for i in results{
//            let tagger = NLTagger(tagSchemes: [.nameType])
//            tagger.string = i.title
//            let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
//            let tags: [NLTag] = [.personalName, .placeName, .organizationName]
//            tagger.enumerateTags(in: i.title!.startIndex..<i.title!.endIndex, unit: .word, scheme: .nameType, options: options) { tag, tokenRange in
//                if let tag = tag, tags.contains(tag) {
//                    print("\(i.title![tokenRange]):")
//                    arr?.append(String(i.title![tokenRange]))
//                }
//                return true
//            }
//        }
//        return arr ?? [""]
//    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == ""{
            isSearch = false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        //        isSearch = false
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isSearch = false
    }
}
extension String {
    func caseInsensitiveHasPrefix(_ prefix: String) -> Bool {
        return lowercased().hasPrefix(prefix.lowercased())
    }
}

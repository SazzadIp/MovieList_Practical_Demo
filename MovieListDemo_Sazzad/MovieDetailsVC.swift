//
//  MovieDetailsVC.swift
//  MovieListDemo_Sazzad
//
//  Created by PCS183 on 19/01/21.
//

import UIKit
import SDWebImage

class MovieDetailsVC: UIViewController {
    @IBOutlet weak var tblMovieList: UITableView!
    
    var movieId:Int = 0
    var moviewDetailsData = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getMoviewDetails()
    }
    
    @IBAction func tapBack(_ sender:Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getMoviewDetails() {
        ServerAPI.shared.getMovieDetailsAPI(movieId: movieId) { (response, status) in
            if status == 1 {
                self.moviewDetailsData = response
                self.tblMovieList.reloadData()
            }else {
                let alert = UIAlertController(title: "Alert", message: "No Data Found", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension MovieDetailsVC:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  moviewDetailsData["overview"] != nil ? 1:0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviewDetailsData["overview"] != nil ? 8:0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieDetailsDescCell") as! MovieDetailsDescCell
        
        if indexPath.row == 0 && moviewDetailsData["overview"] != nil {
            cell.lblMovieTitle.text = "Overview"
            cell.lblMovieDesc.text = (moviewDetailsData["overview"] as? String)!
        }else if indexPath.row == 1 {
            cell.lblMovieTitle.text = "Genres"
            var title = ""
            for item in moviewDetailsData["genres"] as! NSArray  {
                title = title + ((item as! NSDictionary)["name"] as? String)! + " "
            }

            title = title.trimmingCharacters(in: .whitespacesAndNewlines)
            title = title.replacingOccurrences(of: " ", with: ", ")
            
            cell.lblMovieDesc.text = title
        }else if indexPath.row == 2 && moviewDetailsData["runtime"] != nil {
            cell.lblMovieTitle.text = "Duration"
            cell.lblMovieDesc.text = String((moviewDetailsData["runtime"] as? Int)!) + " Minutes"
        }else if indexPath.row == 3 && moviewDetailsData["release_date"] != nil{
            cell.lblMovieTitle.text = "Release Date"
            cell.lblMovieDesc.text = (moviewDetailsData["release_date"] as? String)!
        }else if indexPath.row == 4 {
            cell.lblMovieTitle.text = "Production Companies"
            var title = ""
            for item in moviewDetailsData["production_companies"] as! NSArray  {
                title = title + ((item as! NSDictionary)["name"] as? String)! + " "
            }

            title = title.trimmingCharacters(in: .whitespacesAndNewlines)
            title = title.replacingOccurrences(of: " ", with: ", ")
            
            cell.lblMovieDesc.text = title
        }else if indexPath.row == 5 && moviewDetailsData["budget"] != nil {
            cell.lblMovieTitle.text = "production Budget"
            cell.lblMovieDesc.text = "$" + String((moviewDetailsData["budget"] as? Int)!)
        }else if indexPath.row == 6 && moviewDetailsData["revenue"] != nil{
            cell.lblMovieTitle.text = "Revenue"
            cell.lblMovieDesc.text = "$" + String((moviewDetailsData["revenue"] as? Int)!)
        }else if indexPath.row == 7 {
            cell.lblMovieTitle.text = "Language"
            var title = ""
            for item in moviewDetailsData["spoken_languages"] as! NSArray  {
            title = title + ((item as! NSDictionary)["name"] as? String)! + " "
            }

            title = title.trimmingCharacters(in: .whitespacesAndNewlines)
            title = title.replacingOccurrences(of: " ", with: ", ")
            cell.lblMovieDesc.text = title
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieDetailsHeaderCell") as! MovieDetailsHeaderCell
        
        let url = "https://image.tmdb.org/t/p/w500" + (moviewDetailsData["backdrop_path"] as? String)!
        cell.imgMovieCover.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: ""))
        
        let url1 = "https://image.tmdb.org/t/p/w200" + (moviewDetailsData["poster_path"] as? String)!
        cell.imgMoviePoster.sd_setImage(with: URL(string: url1), placeholderImage: UIImage(named: ""))
        
        cell.lblMovieTitle.text = (moviewDetailsData["title"] as? String)!
        cell.lblMovieDate.text = (moviewDetailsData["tagline"] as? String)!
        
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 250
    }
    
    
}


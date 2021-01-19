//
//  ViewController.swift
//  MovieListDemo_Sazzad
//
//  Created by PCS183 on 19/01/21.
//

import UIKit
import SDWebImage
import CoreData

class MovieListVC: UIViewController {
    @IBOutlet weak var tblMovieList: UITableView!
    
    var lastIndex = 0
    var arryList = [NSDictionary]()
    var isLoad = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getMoviewList()
    }
    
    func getMoviewList() {
        if !isLoad {
            isLoad = true
            ServerAPI.shared.getMovieListAPI(pageIndex: lastIndex+1) { (response, status) in
                self.isLoad = false
                if status == 1 {
                    if self.lastIndex < response["page"] as! Int {
                        for item in response["results"] as! [NSDictionary] {
                            self.arryList.append(item)
                            self.fetchCoreData(id: (item["id"] as? Int)!, item: item)
                        }
                        //                    self.arryList = response["results"] as! [NSDictionary]
                        self.lastIndex = response["page"] as! Int
                        self.tblMovieList.reloadData()
                    }
                }else {
                    let alert = UIAlertController(title: "Alert", message: "No Data Found", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    //MARK:- Checking for Data availbale in core then update or NEw Added
    func fetchCoreData(id:Int, item:NSDictionary) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieList")
        request.predicate = NSPredicate(format: "id = %d", id)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if (result as! [NSManagedObject]).count > 0 { // Atleast one was returned
                (result[0] as AnyObject).setValue((item["title"] is String ? (item["title"] as? String)!:""), forKey: "title")
                (result[0] as AnyObject).setValue((item["release_date"] is String ? (item["release_date"] as? String)!:""), forKey: "release_date")
                (result[0] as AnyObject).setValue((item["poster_path"] is String ? (item["poster_path"] as? String)!:""), forKey: "poster_path")
                (result[0] as AnyObject).setValue((item["overview"] is String ? (item["overview"] as? String)!:""), forKey: "overview")
                appDelegate.saveContext()
            }else {
                self.saveDataToCore(item: item)
            }
        } catch {
            print("Failed")
        }
    }
    
    func saveDataToCore(item:NSDictionary)  {
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue((item["title"] is String ? (item["title"] as? String)!:""), forKey: "title")
        newUser.setValue((item["release_date"] is String ? (item["release_date"] as? String)!:""), forKey: "release_date")
        newUser.setValue((item["poster_path"] is String ? (item["poster_path"] as? String)!:""), forKey: "poster_path")
        newUser.setValue((item["overview"] is String ? (item["overview"] as? String)!:""), forKey: "overview")
        newUser.setValue((item["id"] as? Int)!, forKey: "id")
        appDelegate.saveContext()
    }
}

extension MovieListVC:UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListCell") as! MovieListCell
        let model = arryList[indexPath.row]
        let url = "https://image.tmdb.org/t/p/w200" + (model["poster_path"] is String ? (model["poster_path"] as? String)!:"")
        cell.imgMoviePoster.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "place"))
        cell.lblMovieTitle.text = (model["title"] as? String)!
        cell.lblMovieDate.text = model["release_date"] != nil ? (model["release_date"] as? String)!:""
        cell.lblMovieDesc.text = (model["overview"] as? String)!
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let initVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailsVC") as! MovieDetailsVC
        initVC.movieId = arryList[indexPath.row]["id"] as! Int
        self.navigationController?.pushViewController(initVC, animated: true)
    }
    
    //MARK:- Scrollview Delegate Method
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.getMoviewList()
    }
}


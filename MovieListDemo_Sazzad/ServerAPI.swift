//
//  ServerAPI.swift
//  MovieListDemo_Sazzad
//
//  Created by PCS183 on 19/01/21.
//

import Foundation
import Alamofire

class ServerAPI {
    static let shared = ServerAPI()
    
    func getMovieListAPI(pageIndex index:Int, _ CompletionHandler:@escaping((NSDictionary, Int)-> Void))  {
        let url = "https://api.themoviedb.org/3/discover/movie?api_key=14bc774791d9d20b3a138bb6e26e2579&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=" + String(index)
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case let .success(value):
                print(value)
                if value is NSDictionary && (value as! NSDictionary)["results"] != nil {
                    CompletionHandler(value as! NSDictionary, 1)
                }else {
                    CompletionHandler([:], 2)
                }
            case let .failure(error):
                print(error)
                CompletionHandler([:], 0)
            }
        }
    }
    
    func getMovieDetailsAPI(movieId id:Int, _ CompletionHandler:@escaping((NSDictionary, Int)-> Void))  {
        let url = "https://api.themoviedb.org/3/movie/" + String(id) + "?api_key=14bc774791d9d20b3a138bb6e26e2579&language=en-US"
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case let .success(value):
                print(value)
                if value is NSDictionary {
                    CompletionHandler(value as! NSDictionary, 1)
                }else {
                    CompletionHandler([:], 2)
                }
            case let .failure(error):
                print(error)
                CompletionHandler([:], 0)
            }
        }
    }
}

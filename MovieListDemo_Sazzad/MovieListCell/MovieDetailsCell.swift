//
//  MovieDetailsCell.swift
//  MovieListDemo_Sazzad
//
//  Created by PCS183 on 19/01/21.
//

import Foundation
import UIKit

class MovieDetailsHeaderCell: UITableViewCell  {
    @IBOutlet weak var imgMoviePoster: UIImageView!
    @IBOutlet weak var imgMovieCover: UIImageView!
    @IBOutlet weak var lblMovieTitle: UILabel!
    @IBOutlet weak var lblMovieDate: UILabel!
    @IBOutlet weak var lblMovieDesc: UILabel!
}

class MovieDetailsDescCell: UITableViewCell  {
    @IBOutlet weak var lblMovieTitle: UILabel!
    @IBOutlet weak var lblMovieDesc: UILabel!
}

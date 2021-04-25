//
//  DataModel.swift
//  Movie
//
//  Created by Anton Levin on 13.04.2021.
//

import Foundation

struct Movie {
  var originalTitle: String
  var title: String
  var year: String
  var rate: Double
  var adult:Bool
  var posterImage: String
  var overview: String
  
  init?(json: JSON){
    guard let originalTitle = json["original_title"] as? String,
          let title = json["title"] as? String,
          let year = json["release_date"] as? String,
          let rate = json["vote_average"] as? Double,
          let adult = json["adult"] as? Bool,
          let posterImage = json["poster_path"] as? String,
          let overview = json["overview"] as? String
    else { return nil}
    
    self.originalTitle = originalTitle
    self.title = title
    self.year = year
    self.rate = rate
    self.adult = adult
    self.posterImage = posterImage
    self.overview = overview
  }
}

//
//  GetMovieResponse.swift
//  Movie
//
//  Created by Anton Levin on 25.04.2021.
//

import Foundation

struct GetMovieResponse {
  
  let movie : [Movie]
  init(json: JSON) throws {
    guard let results = json["results"] as? [JSON] else { throw NetworkingError.badNetworking }
    let movie = results.map{Movie(json: $0)}.compactMap{$0}
    self.movie = movie
  }
}


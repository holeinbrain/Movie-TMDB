//
//  Networking.swift
//  Movie
//
//  Created by Anton Levin on 13.04.2021.
//

import UIKit
import Alamofire

typealias JSON = [String: Any]

class NetworkingClient {
  
  static let shared = NetworkingClient()
  private init(){}
  
  var data = [Movie]()
  
  func getData(_ url: URL, success successBlock: @escaping (GetMovieResponse)-> Void){
    AF.request(url, method: .get).validate().responseJSON { response in
      guard let json = response.value as? JSON else { return }
      do{
        let getMovieResponse = try GetMovieResponse(json: json)
        successBlock(getMovieResponse)
      } catch {
        print(error)
      }
    }
  }
}

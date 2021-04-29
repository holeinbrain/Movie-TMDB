//
//  TableViewCell.swift
//  Movie
//
//  Created by Anton Levin on 07.04.2021.
//

import UIKit

class TableViewCell: UITableViewCell {
  
  let blackTextColor = UIColor.AppColors.black
  
  
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var coverImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var originalLable: UILabel!
  @IBOutlet weak var yearLabel: UILabel!
  @IBOutlet weak var ratingLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    initialise()
  }
  
  func initialise() {
    
    backgroundColor = .clear
    selectionStyle = .none
    
    containerView.backgroundColor = UIColor(white: 1, alpha: 0.5)
    containerView.layer.cornerRadius = 12
    
    coverImageView.contentMode = .scaleAspectFill
    coverImageView.layer.cornerRadius = 9
    coverImageView.clipsToBounds = true
    coverImageView.translatesAutoresizingMaskIntoConstraints = false
    
    
    titleLabel.numberOfLines = 2
    titleLabel.textColor = blackTextColor
    titleLabel.font = .customFont(ofSize: 17, weight: .bold)
    titleLabel.textAlignment = .left
    
    yearLabel.textColor = blackTextColor
    yearLabel.font = UIFont.customFont(ofSize: 15, weight: .medium)
    yearLabel.textAlignment = .left
    
    ratingLabel.textColor = UIColor.AppColors.grey
    ratingLabel.font = .systemFont(ofSize: 15, weight: .regular)
    ratingLabel.textAlignment = .center
  }
  
  func configure(from model: Movie) {
    titleLabel.text = model.title
    originalLable.text = model.originalTitle
    yearLabel.text = model.year
    ratingLabel.text = String(model.rate)
    let image = model.posterImage
    
    var imageUrlString = "https://image.tmdb.org/t/p/w300" + image
    
    imageUrlString = imageUrlString.replacingOccurrences(of: " ", with: "%20")
    if let url = URL(string: imageUrlString) {
      URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let data = data {
          DispatchQueue.main.async {
            self.coverImageView.image = UIImage(data: data)
          }
        }
      }.resume()
    }
  }
}


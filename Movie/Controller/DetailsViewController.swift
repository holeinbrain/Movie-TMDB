//
//  DetailsViewController.swift
//  Movie
//
//  Created by Anton Levin on 07.04.2021.
//

import UIKit

class DetailsViewController: UIViewController {
  
  lazy var customView = view as! DetailsView
  let movie: Movie
  
  override func loadView() {
    view = DetailsView(frame: UIScreen.main.bounds)
  }
  
  init(viewModel: Movie) {
    self.movie = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    customView.titleLabel.attributedText = movie.title.formattedString(font: UIFont.customFont(ofSize: 20, weight: .bold), textColor: .black, lineHeight: 28, letterSpace: 0.2, alignment: .center)
    let image2 = movie.posterImage
    var imageUrlString = "https://image.tmdb.org/t/p/w300" + image2
    customView.originalTitleLabel.text = movie.originalTitle
    imageUrlString = imageUrlString.replacingOccurrences(of: " ", with: "%20")
    if let url = URL(string: imageUrlString) {
      URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let data = data {
          DispatchQueue.main.async {
            if let image = UIImage(data: data){
              self.setupImageContainerView(image: image)
            }
          }
        }
      }.resume()
    }
    
    customView.textView.attributedText = movie.overview.formattedString(font: UIFont.systemFont(ofSize: 16, weight: .regular), textColor: .black, lineHeight: 24, letterSpace: 0.5, alignment: .left)
    customView.dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
  }
  
  private func setupImageContainerView(image: UIImage) {
    let averageColor = image.averageColor()
    customView.imageView.image = image
    customView.imageContainerView.firstColor = averageColor
    customView.imageContainerView.secondColor = averageColor.withAlphaComponent(0)
    customView.imageContainerView.horizontalMode = false
  }
  
  @objc private func dismissButtonTapped() {
    dismiss(animated: true, completion: nil)
  }
}

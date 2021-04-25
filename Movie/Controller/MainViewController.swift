//
//  MainViewController.swift
//  Movie
//
//  Created by Anton Levin on 07.04.2021.
//

import UIKit

class MainViewController: UIViewController {
  
  
  
  var data = [Movie]()

let key = "0b47f322dcc57afcb29b86adfe030f18"
var category = "top_rated"
var page = 2

  
    //MARK:- IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Variables
    var detailsViewPresentingAnimator: ViewPresentingAnimator?
    var detailsViewDismissingAnimator: ViewDismissingAnimator?
    var viewModelList = [ViewModel]()
    var didSelectItem: ((_ selectedModel: SelectedViewModel) -> Void)?

    //MARK:- View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
      //              "https://api.themoviedb.org/3/movie/popular?api_key=4e0be2c22f7268edffde97481d49064a&language=ru-US&page=1&"
     
      
        setupTable()
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        tableView.reloadData()
    }
    
    //MARK:- internal methods
    
    private func loadData() {
      let urlString = "https://api.themoviedb.org/3/movie/\(category)?api_key=\(key)&language=ru-US&page=\(page)&"
      guard let url = URL(string: urlString)else {return}
      NetworkingClient.shared.getData(url) { response in
        print(response)
        self.data = response.movie
        self.tableView.reloadData()
      }
      
      
       // viewModelList = MovieData().getData()
    }
    
    private func setupTable() {
        tableView.register(UINib(nibName: "\(TableViewCell.self)", bundle: nil), forCellReuseIdentifier: TableViewCell.description())
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func showDetailsView(selectedModel: SelectedViewModel, HomeView: UIView) {
        let imageRelativeFrame = view.convert(selectedModel.imageViewParentRelativeFrame, from: HomeView)
        detailsViewPresentingAnimator = ViewPresentingAnimator(originImageFrame: imageRelativeFrame, imageView: selectedModel.imageView)
        detailsViewDismissingAnimator = ViewDismissingAnimator(originImageFrame: imageRelativeFrame, imageView: selectedModel.imageView)
//        let viewController = DetailsViewController(viewModel: selectedModel.item)
//        viewController.modalPresentationStyle = .custom
//        viewController.transitioningDelegate = self
//        present(viewController, animated: true, completion: nil)
    }
}

//MARK:- UITableViewDataSource & UITableViewDelegate Methods

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.description(), for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        cell.configure(from: data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TableViewCell else {
            return
        }
        let imageRelativeFrame = view.convert(cell.coverImageView.frame, from: cell.containerView)
        let model = SelectedViewModel(item: viewModelList[indexPath.row], imageView: cell.coverImageView, imageViewParentRelativeFrame: imageRelativeFrame)
        DispatchQueue.main.async {
            self.showDetailsView(selectedModel: model, HomeView: self.view)
        }
    }
}

//MARK:- UIViewControllerTransitioningDelegate Methods

extension MainViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return detailsViewPresentingAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return detailsViewDismissingAnimator
    }
}

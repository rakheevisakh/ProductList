//
//  ProductsViewController.swift
//  ProductsListApp
//
//  Created by Rakhee Visakh on 07/05/25.
//

import UIKit
import Combine

class ProductsViewController: UIViewController {
    @IBOutlet weak var tblViewProducts: UITableView!
    var dataSource: UITableViewDiffableDataSource<Int, Products>!
    var productsViewModel:ProductsViewModel = ProductsViewModel(categoryName: "")
    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        tblViewProducts.register(ProductTableViewCell.nib, forCellReuseIdentifier: ProductTableViewCell.identifier)
        setupDataSource()
        productsViewModel.getProducts()
        bindViewModelToView()
        // Do any additional setup after loading the view.
    }

    // MARK: - Setup Data Source
    func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, Products>(tableView: tblViewProducts) { tableView, indexPath, product in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier, for: indexPath) as? ProductTableViewCell else {
                return UITableViewCell()
            }
            cell.title.text = product.title
            if let url = URL(string: product.image) {
                cell.imageProducts.load(url: url)
            }
            cell.ratings.text = " \(product.rating.rate), \(product.rating.count) views"
            cell.desc.text = product.description
            cell.price.text = "$\(product.price)"
            return cell
        }
    }

    private func bindViewModelToView() {
        ActivityIndicatorView.shared.startLoading(view: self.view)
        productsViewModel.$products
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] products in
                self?.updateSections(products: products)
            }
            .store(in: &cancellables)
       
        
        let stateValueHandler: (ProductsViewModelState) -> Void = { [weak self] state in
                       switch state {
                       case .loading:
                           print("loading..")
                           ActivityIndicatorView.shared.startLoading(view: self!.view)
                       case .finishedLoading:
                           print("finished loading")
                           ActivityIndicatorView.shared.stopLoading()
                       case .error(let error):
                           ActivityIndicatorView.shared.stopLoading()
                           self?.showError(error)
                       }
                   }
        
        productsViewModel.$state
            .receive(on: RunLoop.main)
            .sink(receiveValue: stateValueHandler)
            .store(in: &cancellables)
    }
    
    func updateSections(products: [Products]) {
        guard dataSource != nil else {
            print("dataSource is nil!")
            ActivityIndicatorView.shared.stopLoading()
            return
        }
        var snapshot = NSDiffableDataSourceSnapshot<Int, Products>()
        snapshot.appendSections([0])
        snapshot.appendItems(products)
        dataSource.apply(snapshot, animatingDifferences: true)
        ActivityIndicatorView.shared.stopLoading()
    }
    
    private func showError(_ error: Error) {
          let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
          let alertAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
              self.dismiss(animated: true, completion: nil)
          }
          alertController.addAction(alertAction)
          present(alertController, animated: true, completion: nil)
      }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

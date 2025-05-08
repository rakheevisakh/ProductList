//
//  CategoryListViewController.swift
//  ProductsListApp
//
//  Created by Rakhee Visakh on 07/05/25.
//

import UIKit
import Combine

class CategoryListViewController: UIViewController {
    @IBOutlet weak var tblViewCategory: UITableView!
    var categoryViewModel : CategoryViewModel = CategoryViewModel()
    var dataSource: UITableViewDiffableDataSource<Int, String>!
    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        categoryViewModel.getCategories()
        bindViewModelToView()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Setup Data Source
     func setupDataSource() {
         dataSource = UITableViewDiffableDataSource<Int, String>(tableView: tblViewCategory) { tableView, indexPath, category in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
            cell.textLabel?.text = category.capitalized
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            return cell
        }
      
    }
    
    private func bindViewModelToView() {
           // AppLoader.shared.startLoading(view: self.view)
        categoryViewModel.$category
            .receive(on: RunLoop.main)
            .sink { [weak self] categories in
                self?.updateSections(category: categories)
            }
            .store(in: &cancellables)
        
        let stateValueHandler: (CategoryViewModelState) -> Void = { [weak self] state in
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
        
        categoryViewModel.$state
            .receive(on: RunLoop.main)
            .sink(receiveValue: stateValueHandler)
            .store(in: &cancellables)
    }
    
    func updateSections(category: [String]) {
        guard dataSource != nil else {
            print("dataSource is nil!")
            ActivityIndicatorView.shared.stopLoading()
            return
        }
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(category)
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
}

extension CategoryListViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCategory = dataSource.itemIdentifier(for: indexPath) else { return }
               print("Selected Category: \(selectedCategory)")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let productsVC = storyboard.instantiateViewController(withIdentifier: AppConstants.productsVCIdentifier) as! ProductsViewController
        productsVC.productsViewModel = ProductsViewModel(categoryName: selectedCategory)
        self.navigationController?.pushViewController(productsVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

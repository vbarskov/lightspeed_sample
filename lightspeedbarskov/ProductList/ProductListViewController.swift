//
//  ProductListViewController.swift
//  lightspeedbarskov
//
//  Created by flappa on 04.11.2024.
//

import UIKit

@MainActor
protocol ProductListDisplayLogic: AnyObject {
    func displayData(viewModel: ProductListFlow.InputData.ViewModel)
    func displayAlert(viewModel: ProductListModels.AlertViewModel)
}

public final class ProductListViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var interactor: ProductListBusinessLogic?
    var router: (ProductListRoutingLogic & ProductListDataPassing)?
    
    lazy var contentView: ProductListViewLogic = ProductListView()
    
    // MARK: - Private Properties
    
    //
    
    // MARK: - Lifecycle
    
    public override func loadView() {
        view = contentView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    // MARK: - Public Methods
    
    //
    
    // MARK: - Requests
    
    //
    
    // MARK: - Private Methods
    
    private func configure() {
        contentView.output = self
        interactor?.onViewDidLoad(request: ProductListFlow.InputData.Request())
    }
    
    // MARK: - UI Actions
    
    //
}

// MARK: - View Output

extension ProductListViewController: ProductListViewOutput {
    
    func loadData() {
        interactor?.onRefreshRequested(request: ProductListFlow.InputData.Request())
    }
    
    func loadMoreData() {
        interactor?.onLoadMoreRequested(request: ProductListFlow.LoadMore.Request())
    }
        
}

// MARK: - Display Logic

extension ProductListViewController: ProductListDisplayLogic {
    
    func displayData(viewModel: ProductListFlow.InputData.ViewModel) {
        self.contentView.update(viewModel: viewModel)
    }
    
    func displayAlert(viewModel: ProductListModels.AlertViewModel) {
        
        let alert = UIAlertController(title: viewModel.title, message: viewModel.text, preferredStyle: .alert)
        
        switch viewModel.alertType {
        case .error:
            let retryAction = UIAlertAction(title: "TRY AGAIN", style: .default) { _ in
                self.interactor?.onViewDidLoad(request: ProductListFlow.InputData.Request())
            }
            alert.addAction(retryAction)
            
        default:
            break
        }
        
        present(alert, animated: true)
    }
}




//
//  ProductListInteractor.swift
//  lightspeedbarskov
//
//  Created by flappa on 04.11.2024.
//

import Foundation


protocol ProductListBusinessLogic {
    
    func onViewDidLoad(request:ProductListFlow.InputData.Request)
    func onRefreshRequested(request:ProductListFlow.InputData.Request)
    func onLoadMoreRequested(request:ProductListFlow.LoadMore.Request)
    
}

protocol ProductListDataStore {
    
}

final class ProductListInteractor: ProductListBusinessLogic, ProductListDataStore {
    
    // MARK: - Public Properties
    
    var presenter: ProductListPresentationLogic?
    lazy var worker: ProductListWorkingLogic = ProductListWorker()
    
    // MARK: - Private Properties
    
    private var isLoading: Bool = false
    
    // MARK: - Business Logic
    
    func onViewDidLoad(request:ProductListFlow.InputData.Request) {
        worker.clear()
        presentData()
        fetchProducts()
    }
    
    func onRefreshRequested(request: ProductListFlow.InputData.Request) {
        worker.clear()
        presentData()
        fetchProducts()
    }
    
    func onLoadMoreRequested(request: ProductListFlow.LoadMore.Request) {
        fetchProducts()
    }
    
    private func presentData(isInitial: Bool = false)  {
        let reponse = ProductListFlow.InputData.Response(state: worker.state, products: worker.products, imageLoadingTasks: worker.imageLoadingTasks)
        self.presenter?.presentData(response: reponse)
    }
}

extension ProductListInteractor {
    
    func fetchProducts() {
        Task {
            do {
                try await worker.fetchProducts()
            } catch {
                self.presenter?.presentLoadDataFailure(response: ProductListFlow.LoadDataFailure.Response(error: error))
            }
            presentData()
        }
    }
    
}

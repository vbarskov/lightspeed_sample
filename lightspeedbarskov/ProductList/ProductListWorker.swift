//
//  ProductListWorker.swift
//  lightspeedbarskov
//
//  Created by flappa on 04.11.2024.
//

import Foundation


protocol ProductListWorkingLogic {
    var state: Business.Common.DataState.State { get }
    var products: [Business.ProductList.Product] { get }
    var imageLoadingTasks: [String: ManagedAsyncTask<Data?>] { get }
    
    func fetchProducts() async throws
    func clear()
}

final class ProductListWorker: ProductListWorkingLogic {
    
    private enum Constants {
        static let limit: Int = 20
    }
    
    private(set) var currentPage = 0
    private(set) var products: [Business.ProductList.Product] = []
    private(set) var imageLoadingTasks: [String: ManagedAsyncTask<Data?>] = [:]
    
    private(set) var state: Business.Common.DataState.State = .undefined
    
    
    // MARK: - Private Properties
    
    private let network: NetworkService = NetworkService()
    
    // MARK: - Working Logic
    
    func fetchProducts() async throws {
        guard state != .loading else { return }
        
        state = .loading
        
        if !products.isEmpty {
            currentPage += 1
        }
        
        do {
            let params = Requests.Products.ProductsParams(limit: Constants.limit, skip: currentPage * Constants.limit)
            let response = try await network.fetchProducts(params: params)
            let newItems = response.products.map { Business.ProductList.Product(product: $0) }
            
            if !newItems.isEmpty {
                products += newItems
                for product in newItems {
                    if let imageUrl = product.images.first {
                        imageLoadingTasks[imageUrl] = loadImageData(from: imageUrl)
                    }
                }
                state = .dataLoaded
            } else {
                state = .allDataLoaded
            }
        } catch {
            state = .error
            throw error
        }
    }
    
    func loadImageData(from urlString: String) -> ManagedAsyncTask<Data?>? {
        
        let retryableTask: ManagedAsyncTask<Data?> = ManagedAsyncTask { [weak self] in
            do {
                let data = try await self?.network.getImageData(urlString: urlString)
                return data
            } catch {
                throw error
            }
        }
        
        return retryableTask
    }
    
    
    func clear() {
        currentPage = 0
        products.removeAll()
        imageLoadingTasks.removeAll()
        state = .initial
    }
    
}


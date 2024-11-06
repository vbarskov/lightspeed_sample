//
//  ProductListFlow.swift
//  lightspeedbarskov
//
//  Created by flappa on 04.11.2024.
//

import UIKit

enum ProductListFlow {
  
    enum InputData {
        struct Request {}
        struct Response {
            let state: Business.Common.DataState.State
            let products: [Business.ProductList.Product]
            let imageLoadingTasks: [String:ManagedAsyncTask<Data?>]
        }
        typealias ViewModel = ProductListModels.ViewModel
    }
    enum LoadMore {
        struct Request { }
        struct Response { }
        struct ViewModel { }
    }
    
    
    struct LoadDataFailure {
        struct Request {}
        
        struct Response {
            let error: Error
        }
        
        typealias ViewModel = ProductListModels.AlertViewModel
    }
    
}

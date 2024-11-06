//
//  ProductListRouter.swift
//  lightspeedbarskov
//
//  Created by flappa on 04.11.2024.
//

import UIKit


protocol ProductListRoutingLogic {
    func routeBack(toRoot: Bool)
}

protocol ProductListDataPassing {
    var dataStore: ProductListDataStore? { get }
}

final class ProductListRouter: ProductListRoutingLogic, ProductListDataPassing {
    
    // MARK: - Public Properties
    
    weak var parentController: UIViewController?
    weak var viewController: ProductListViewController?
    var dataStore: ProductListDataStore?
    
    // MARK: - Private Properties
    
    //
    
    // MARK: - Routing Logic
    
    func routeBack(toRoot: Bool) {
        
    }
    
    // MARK: - Navigation
    
    //
    
    // MARK: - Passing data
    
    //
}

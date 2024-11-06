//
//  ProductListBuilder.swift
//  lightspeedbarskov
//
//  Created by flappa on 04.11.2024.
//

import UIKit


protocol ProductListBuildingLogic: AnyObject {
    func makeScene(parent: UIViewController?) -> ProductListViewController
}

public final class ProductListBuilder: ProductListBuildingLogic {
    
    // MARK: - Public Methods
    
    public init() { }
    
    public func makeScene(parent: UIViewController? = nil) -> ProductListViewController {
        let viewController = ProductListViewController()
        
        let interactor = ProductListInteractor()
        let presenter = ProductListPresenter()
        let router = ProductListRouter()
        
        interactor.presenter = presenter
        presenter.viewController = viewController
        
        router.parentController = parent
        router.viewController = viewController
        router.dataStore = interactor
        
        viewController.interactor = interactor
        viewController.router = router
        
        return viewController
    }
}

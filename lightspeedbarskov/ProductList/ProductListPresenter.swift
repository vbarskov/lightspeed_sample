//
//  ProductListPresenter.swift
//  lightspeedbarskov
//
//  Created by flappa on 04.11.2024.
//

import UIKit


protocol ProductListPresentationLogic {
    func presentData(response: ProductListFlow.InputData.Response)
    func presentLoadDataFailure(response: ProductListFlow.LoadDataFailure.Response)
}

final class ProductListPresenter: ProductListPresentationLogic {
    
    
    // MARK: - Public Properties
    
    weak var viewController: ProductListDisplayLogic?
    
    // MARK: - Private Properties
    private let backgroundQueue = DispatchQueue(label: "ProductListPresenterQueue", qos: .userInitiated)
    
    
    // MARK: - Presentation Logic

    func presentData(response: ProductListFlow.InputData.Response) {
        backgroundQueue.async {
            if let viewModel = self.contextCreation(response: response) {
                Task {
                    await self.viewController?.displayData(viewModel: viewModel)
                }
            }
        }
    }
    
    private func contextCreation(response: ProductListFlow.InputData.Response) -> ProductListFlow.InputData.ViewModel? {
                        
        let backgroundColor: UIColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor.black : UIColor.white
        }
        
        let viewModelItems = response.products.map {
            
            let titleColor = UIColor { traitCollection in
                return traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
            }
            
            let priceColor = UIColor.green
            let qtyColor = UIColor.blue
            let descriptionColor = UIColor.gray
            
            let titleFont = UIFontMetrics.default.scaledFont(for: UIFont.boldSystemFont(ofSize: 16))
            let descriptionFont = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 14))
            let priceFont = UIFontMetrics.default.scaledFont(for: UIFont.boldSystemFont(ofSize: 16))
            let qtyFont = UIFontMetrics.default.scaledFont(for: UIFont.italicSystemFont(ofSize: 14))
            
            let titleAttributedString = NSAttributedString(string: $0.title, attributes: [
                .foregroundColor: titleColor,
                .font: titleFont
            ])
            
            let descriptionAttributedString = NSAttributedString(string: $0.description, attributes: [
                .foregroundColor: descriptionColor,
                .font: descriptionFont
            ])
            
            let priceAttributedString = NSAttributedString(string: "Price: \(String($0.price))", attributes: [
                .foregroundColor: priceColor,
                .font: priceFont
            ])
            
            let qtyAttributedString = NSAttributedString(string: "Quantity: \(String($0.stock))", attributes: [
                .foregroundColor: qtyColor,
                .font: qtyFont
            ])
            
            let vm = ProductCellVM(
                id: $0.id,
                title: titleAttributedString,
                descr: descriptionAttributedString,
                price: priceAttributedString,
                qty: qtyAttributedString,
                imageLoadingTask: response.imageLoadingTasks[$0.images.first ?? ""] ?? ManagedAsyncTask(taskClosure: {Data()}),
                backgroundColor: backgroundColor,
                isLoading: response.state == .loading
            )
            
            return vm
        }
        
        return ProductListFlow.InputData.ViewModel(items: viewModelItems, state: response.state)
    }
    
    func presentLoadDataFailure(response: ProductListFlow.LoadDataFailure.Response) {
        Task {
            let alertViewModel: ProductListModels.AlertViewModel
            
            switch response.error {
            case is NetworkError:
                switch response.error as? NetworkError {
                case .invalidURL:
                    alertViewModel = ProductListModels.AlertViewModel(
                        alertType: .error,
                        title: "Invalid URL",
                        text: "Provided URL is not valid."
                    )
                    
                case .badResponse:
                    alertViewModel = ProductListModels.AlertViewModel(
                        alertType: .error,
                        title: "Network Error",
                        text: "Server response was invalid. Please try again later."
                    )
                    
                case .none:
                    alertViewModel = ProductListModels.AlertViewModel(
                        alertType: .error,
                        title: "Unknown Network Error",
                        text: "An unexpected network error occurred. Please try again."
                    )
                }
                
            default:
                alertViewModel = ProductListModels.AlertViewModel(
                    alertType: .error,
                    title: "Error...",
                    text: "Something went wrong. Please try again."
                )
            }
            
            await viewController?.displayAlert(viewModel: alertViewModel)
        }
    }
    
}


extension ProductListPresenter {
        
    
}

//
//  ProductListModels.swift
//  lightspeedbarskov
//
//  Created by flappa on 04.11.2024.
//

import UIKit


enum ProductListModels {
    
    // MARK: - Models
        
    enum ViewItems {
        enum CollectionItems {
            case some
        }
    }
    
    // MARK: - View Models
    
    struct ViewModel {
        let items: [Any]
        let state: Business.Common.DataState.State
        
        func changeValues(items: [Any]) -> ViewModel {
            ViewModel(
                items: items,
                state: state
            )
        }
    }
    
    enum AlertType {
        case error
        case success
        case warning
        case info
    }
    
    struct AlertViewModel {
        public let alertType: AlertType
        public let title: String
        public let text: String
        
        public init(
            alertType: AlertType,
            title: String,
            text: String
        ) {
            self.alertType = alertType
            self.title = title
            self.text = text
        }
    }
   
}

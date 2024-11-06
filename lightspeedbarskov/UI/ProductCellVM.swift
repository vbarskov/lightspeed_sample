//
//  ProductCellVM.swift
//  lightspeedbarskov
//
//  Created on 05.11.2024.
//

import UIKit

public protocol ProductCellVMOutput: AnyObject {
    
    
}

public class ProductCellVM {
        
    public let id: AnyHashable
    public let title: NSAttributedString
    public let descr: NSAttributedString
    public let price: NSAttributedString
    public let qty: NSAttributedString
    public let imageLoadingTask: ManagedAsyncTask<Data?>?
    public let backgroundColor: UIColor
    public let isLoading: Bool
    
    public weak var output: ProductCellVMOutput?
    
    public init(
            id: AnyHashable,
            title: NSAttributedString,
            descr: NSAttributedString,
            price: NSAttributedString,
            qty: NSAttributedString,
            imageLoadingTask: ManagedAsyncTask<Data?>?,
            backgroundColor: UIColor,
            isLoading: Bool,
            output: ProductCellVMOutput? = nil
        ) {
            self.id = id
            self.title = title
            self.descr = descr
            self.price = price
            self.qty = qty
            self.imageLoadingTask = imageLoadingTask
            self.backgroundColor = backgroundColor
            self.isLoading = isLoading
            self.output = output
        }
    
    
}








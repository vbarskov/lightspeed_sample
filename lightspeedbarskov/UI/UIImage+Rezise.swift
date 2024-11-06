//
//  UIImage+Rezise.swift
//  lightspeedbarskov
//
//  Created by flappa on 05.11.2024.
//

import UIKit

public extension UIImage {
    func imageResized(to size: CGSize) -> UIImage {
        let aspectWidth = size.width / self.size.width
        let aspectHeight = size.height / self.size.height
        let aspectRatio = min(aspectWidth, aspectHeight)
        
        let newSize = CGSize(width: self.size.width * aspectRatio, height: self.size.height * aspectRatio)
        
        return UIGraphicsImageRenderer(size: newSize).image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}

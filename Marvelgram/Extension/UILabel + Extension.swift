//
//  UILabel + Extension.swift
//  Marvelgram
//
//  Created by Sergey Savinkov on 02.08.2023.
//

import UIKit

extension UILabel {
    
    convenience init(text: String, font: UIFont?) {
        self.init()
        
        self.text = text
        self.font = font
        
        self.textColor = .white
        self.numberOfLines = 0
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

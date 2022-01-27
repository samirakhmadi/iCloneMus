//
//  UIViewController+Extension.swift
//  ListAlbum
//
//  Created by pioner on 06.01.2022.
//

import UIKit

extension UIViewController {
    
    func createCustomButton(selector: Selector,title: String?, image: UIImage?) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        if let image = image {
            button.setImage(image, for: .normal)
        } else {
            let title = title ?? "Button"
            button.setTitle(title, for: .normal)
        }
        button.tintColor = .black
        button.addTarget(self, action: selector, for: .touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: button)
        return menuBarItem
    }
    
}

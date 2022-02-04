//
//  UIVIewController + Extension.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 31.01.2022.
//

import UIKit

extension UIViewController {
    
    func createCustomButton(selector: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "person.fill"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: selector, for: .touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: button)
        return menuBarItem
    }
}

//
//  NavigationBarItem.swift
//  app-common
//
//  Created by Satya Surya on 12/23/22.
//

import Foundation
import UIKit

public struct NavigationBarItem {
    let shouldHide: Bool
    let title: String
    let leftButtons: [NavigationBarButtonType]?
    let rightButtons: [NavigationBarButtonType]?
    
    public init(shouldHide: Bool, title: String, leftButtons: [NavigationBarButtonType]? = nil, rightButtons: [NavigationBarButtonType]? = nil) {
        self.shouldHide = shouldHide
        self.title = title
        self.leftButtons = leftButtons
        self.rightButtons = rightButtons
    }
}

// Extension for adding bar button actions.
public extension UIViewController {
    // Back button
    func backButton() -> UIBarButtonItem {
        let image = UIImage(named: "back")
        let menuButton = UIBarButtonItem(image: image,
                                         style: .plain,
                                         target: self,
                                         action: #selector(backClicked))
        menuButton.tintColor = UIColor.black
        return menuButton
    }

    @objc func backClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    // Close button
    func closeButton() -> UIBarButtonItem {
        let image = UIImage(named: "close")
        let menuButton = UIBarButtonItem(image: image,
                                         style: .plain,
                                         target: self,
                                         action: #selector(closeClicked))
        menuButton.tintColor = UIColor.black
        return menuButton
    }

    @objc func closeClicked() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

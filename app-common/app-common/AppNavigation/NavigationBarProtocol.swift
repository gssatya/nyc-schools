//
//  NavigationBarProtocol.swift
//  app-common
//
//  Created by Satya Surya on 12/23/22.
//

import Foundation
import UIKit

// Nav bar UI button type
public enum NavigationBarButtonType {
    case back
    case close
}

/// Protocol class to setup Nav bar UI
public protocol NavigationBarProtocol where Self: UIViewController {
    
    /// Protocol method to add the navigation bar UI to the view controller
    func addNavigationBar()
    
    /// Protocol method to configure the Nav bar
    /// - Returns: NavigationBarItem
    func getNavigationBar() -> NavigationBarItem
}

public extension NavigationBarProtocol {
    
    func addNavigationBar() {
        
        // Get the Nav bar model
        let navItem = self.getNavigationBar()
        
        // Set hidden and title attributes
        navigationController?.setNavigationBarHidden(navItem.shouldHide, animated: false)
        title = navItem.title
        
        // Set appearance
        let font = UIFont(name: "HelveticaNeue-Bold", size: 17) ?? UIFont.systemFont(ofSize: 17)
        let color = UIColor.black
        let bgColor = UIColor(red: 0.969, green: 0.969, blue: 0.980, alpha: 1.0)
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: color,
                                                          NSAttributedString.Key.font: font]
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = bgColor
        appearance.titleTextAttributes = attributes
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // Set left buttons
        if let leftButtons = navItem.leftButtons {
            let buttons = generateBarButtons(leftButtons)
            if buttons.count > 0 {
                navigationItem.leftBarButtonItems = buttons
            } else {
                let button = UIBarButtonItem.init(title: nil, style: .plain, target: nil, action: nil)
                navigationItem.leftBarButtonItem = button
            }
        } else {
            navigationItem.leftBarButtonItems = nil
            navigationItem.hidesBackButton = true
        }
        
        // Set right buttons
        if let rightButtons = navItem.rightButtons {
            let buttons = generateBarButtons(rightButtons)
            if buttons.count > 0 {
                navigationItem.rightBarButtonItems = buttons
            } else {
                let button = UIBarButtonItem.init(title: nil, style: .plain, target: nil, action: nil)
                navigationItem.rightBarButtonItem = button
            }
        } else {
            navigationItem.rightBarButtonItems = nil
        }
        
    }
    
    /// Method to get the buttons needed for Nav bar
    /// - Parameter buttons: array of button types.
    private func generateBarButtons(_ buttons: [NavigationBarButtonType]) -> [UIBarButtonItem] {
        var barButtons: [UIBarButtonItem] = []
        for button in buttons {
            let barButton = getBarButton(for: button)
            barButtons.append(barButton)
        }
        return barButtons
    }
    
    /// Get the button for the type
    /// - Parameter type:
    private func getBarButton(for type: NavigationBarButtonType) -> UIBarButtonItem {
        
        switch type {
        case .back:
            return backButton()
        case .close:
            return closeButton()
        }
    }
}

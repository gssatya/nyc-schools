//
//  AppRouter.swift
//  app-common
//
//  Created by Satya Surya on 12/23/22.
//

import Foundation
import UIKit

// MARK: - Navigation Payload Protocol

/// A protocol to support pass any data during navigation.
public protocol NavigationPayloadProtocol {
    var payload: [String: Any]? { get set }
}

// MARK: - Navigation Style Enum

/// Enum to define the navigating style
public enum NavigationStyle {
    case push
    case present
}

// MARK: - App Router

/// Singleton class to handle the Navigation in a common place.
public class AppRouter {
    
    public static var shared = AppRouter()
    
    private init() {
        // Intentionally left blank
    }
    
    /// Method to navigate to a new view controller
    /// - Parameters:
    ///   - identifier: Storyboard identifier
    ///   - storyboard: Storyboard name
    ///   - payload: payload to pass.
    ///   - animated: animated
    ///   - navigationStyle: push/present
    public func navigateTo(identifier: String, storyboard: String = "Main",
                    payload: [String: Any]? = nil, animated: Bool = true,
                    navigationStyle: NavigationStyle = .push) {
        
        guard Thread.isMainThread else {
            assertionFailure("UI updates should run in main thread")
            return
        }
        
        guard let topNav = getTopNavigationController() else { return }
        let storyboard = UIStoryboard(name: storyboard, bundle: Bundle.main)
        let destVC = storyboard.instantiateViewController(withIdentifier: identifier)
        
        // Set up the payload for all NavigationPayloadProtocol
        if var payloadProtocol = destVC as? NavigationPayloadProtocol {
            payloadProtocol.payload = payload
        }
        
        switch navigationStyle {
        case .push:
            topNav.pushViewController(destVC, animated: animated)
        case .present:
            var navigationController = UINavigationController(rootViewController: destVC)
            setupNavigationController(&navigationController)
            navigationController.modalPresentationStyle = .overFullScreen
            topNav.present(navigationController, animated: animated, completion: nil)
        }
        
        setNavBarUI(destVC)
    }
}

extension AppRouter {
    
    /// Method to get the top most Nav controller
    /// - Returns: UINavigationController
    private func getTopNavigationController() -> UINavigationController? {
        return UIViewController.top?.navigationController
    }
    
    /// Initially hide the nav bar for Nav controller
    /// - Parameter navC: Inout param
    private func setupNavigationController(_ navC: inout UINavigationController) {
        navC.setNavigationBarHidden(true, animated: false)
        navC.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navC.navigationBar.shadowImage = UIImage()
    }
    
    /// Method to set up Nav bar UI after navigation
    /// - Parameter controller: UIViewController
    private func setNavBarUI(_ controller: UIViewController) {
        if let navBarProtocol = controller as? NavigationBarProtocol {
            navBarProtocol.addNavigationBar()
        }
    }
}


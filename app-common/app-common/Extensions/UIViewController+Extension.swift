//
//  UIViewController+Extension.swift
//  app-common
//
//  Created by Satya Surya on 12/23/22.
//

import Foundation

import UIKit

public extension UIViewController {
    static var top: UIViewController? {
        return topViewController()
    }

    static var navRoot: UINavigationController? {
        return UIApplication.shared.delegate?.window??.rootViewController as? UINavigationController
    }

    static var root: UIViewController? {
        return UIApplication.shared.delegate?.window??.rootViewController
    }

    static func topViewController(from viewController: UIViewController? = UIViewController.root) -> UIViewController? {
        var resultVC: UIViewController? = viewController
        if let tabBarViewController = viewController as? UITabBarController {
            resultVC = topViewController(from: tabBarViewController.selectedViewController)
        } else if let navigationController = viewController as? UINavigationController {
            resultVC = topViewController(from: navigationController.visibleViewController)
        } else if let presentedViewController = viewController?.presentedViewController {
            resultVC = topViewController(from: presentedViewController)
        }
        return resultVC
    }
    
    var isModal: Bool {
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
    
    /// Extension method to present UIAlerts
    /// - Parameters:
    ///   - style: Alert stye (.alert or .actionSheet)
    ///   - title: Title String (optional)
    ///   - message: message string (optional)
    ///   - cancelButtonTitle: title for cancel button (optional)
    ///   - otherButtons: array of  UIAlertAction (optional)
    ///   - hideCancelButton: Bool to hide cancel button (optional)
    func showAlert(style: UIAlertController.Style,
                   title: String? = nil,
                   message: String? = nil,
                   cancelButtonTitle: String = "Cancel",
                   otherButtons: [UIAlertAction]? = nil,
                   hideCancelButton: Bool = false,
                   sourceView: UIView? = nil) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: style)

        if !hideCancelButton {
            let cancelActionButton = UIAlertAction(title: cancelButtonTitle, style: .cancel) { _ in
                // Intentionally left blank
            }
            alert.addAction(cancelActionButton)
        }

        if let buttons = otherButtons {
            for button in buttons {
                alert.addAction(button)
            }
        }
        
        // Handling action sheet pope over for iPad.
        if UIDevice.isIPad, style == .actionSheet, let sourceView = sourceView {
            alert.popoverPresentationController?.sourceView = sourceView
            alert.popoverPresentationController?.sourceRect = sourceView.bounds
        }

        present(alert, animated: true, completion: nil)
    }
    
//    /// Extension method to display loader
//    func showLoader() {
//        ActivityLoader.show()
//    }
//
//    /// Extension method to remove loader
//    func hideLoader() {
//        ActivityLoader.hide()
//    }
}

extension NSObject {
    public var onlyClassName: String {
        return String(describing: type(of: self)).components(separatedBy: ".").last ?? ""
    }
}


//
//  UIDevice+Extension.swift
//  app-common
//
//  Created by Satya Surya on 12/23/22.
//

import Foundation
import UIKit

public extension UIDevice {
    
    /// static var to recognize iPad.
    static var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
}

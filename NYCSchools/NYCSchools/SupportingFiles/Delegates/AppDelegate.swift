//
//  AppDelegate.swift
//  NYCSchools
//
//  Created by Satya Surya on 12/23/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIViewController.swizzle()
        return true
    }

}


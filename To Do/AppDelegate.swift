//
//  AppDelegate.swift
//  To Do
//
//  Created by Raymond Tsang on 9/21/18.
//  Copyright © 2018 Raymond Tsang. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // The file path of the realm data
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do {
            _ = try Realm()
        } catch {
            print("error initializing realm")
        }
        
        return true
    }
    
}

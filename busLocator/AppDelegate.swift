//
//  AppDelegate.swift
//  busLocator
//
//  Created by Laura Sofía on 26/03/18.
//  Copyright © 2018 isis3510. All rights reserved.
//

import UIKit
import AFNetworking
import GoogleMaps

var baseURL:URL = URL(string: "https://api.myjson.com/")!
let manager = AFHTTPSessionManager(baseURL: baseURL as URL!)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyDt-nCZFIAFQzyV7xF-0DHuW_T6KvwexnA")
        return true
    }


}


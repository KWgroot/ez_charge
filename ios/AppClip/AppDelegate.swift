//
//  AppDelegate.swift
//  AppClip
//
//  Created by Rick Schut on 08/12/2020.
//

//import UIKit
//import Flutter

//@main
//class AppDelegate: FlutterAppDelegate {

//    lazy var flutterEngine = FlutterEngine(name:"my flutter engine")

//    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        return true
//        flutterEngine.run(withEntrypoint: "otherEntrypoint", libraryURI: "app_main.dart")
//       / GeneratedPluginRegistrant.register(with: self);
//        return super.application(application, didFinishLaunchingWithOptions: launchOptions);
//    }

    // MARK: UISceneSession Lifecycle

//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }

//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }


//}

import UIKit
import Flutter

@UIApplicationMain
class AppDelegate: FlutterAppDelegate {
    
  lazy var flutterEngine = FlutterEngine(name:"my flutter engine")
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    flutterEngine.run(withEntrypoint: "main", libraryURI: "app_main.dart")
    GeneratedPluginRegistrant.register(with: self.flutterEngine);
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

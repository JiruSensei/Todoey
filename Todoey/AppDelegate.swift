//
//  AppDelegate.swift
//  Todoey
//
//  Created by Gilles Poirot on 15/05/2018.
//  Copyright © 2018 iJiru. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    // La première méthode qui sera appelée de notre application
    // avant même le viewDidLoad() de notre ViewController principal
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Ici on imprime le chemin où se trouvera le fichier .plist et dedans la base UserDefaults
        // avec une entrée pour chaque Key, et dans notre cas on a une Key pour un Array
        // du coup quand on ajoute un nouvel item il va dans le tableau sans créer une nouvelle entrée dans plist.
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        return true
    }

    // Méthode appelée avant qu'on passe en background
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state.
        // This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or
        // when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks.
        //Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store
        // enough application state information to restore your application to its current state in case
        // it is terminated later. If your application supports background execution,
        // this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


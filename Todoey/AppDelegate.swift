//
//  AppDelegate.swift
//  Todoey
//
//  Created by Gilles Poirot on 15/05/2018.
//  Copyright © 2018 iJiru. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    // La première méthode qui sera appelée de notre application
    // avant même le viewDidLoad() de notre ViewController principal
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Voici juste un print permettant de voir où se trouve le fichier Realm
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        // On crée le "container" realm qui potentiellement peut lever une error
        do {
            _ = try Realm()
        } catch {
            print("Erreur lors de l'initialisation de Realm \(error)")
        }

        return true
    }

}


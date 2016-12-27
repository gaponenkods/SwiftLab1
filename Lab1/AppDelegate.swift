//
//  AppDelegate.swift
//  Lab1
//
//  Created by Konstantyn Byhkalo on 12/13/16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        let navigationController = self.window!.rootViewController as! UINavigationController
//        let masterController = navigationController.topViewController as! MasterViewController
//        masterController.managedObjectContext = self.persistentContainer.viewContext
        return true
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Lab1")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                               fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension AppDelegate {
    
    static let sharedDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static func saveContext () {
        let appDelegate = AppDelegate.sharedDelegate
        appDelegate.saveContext()
    }
    
}

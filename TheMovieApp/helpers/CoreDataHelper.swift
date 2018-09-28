//
//  CoreDataHelper.swift
//  TheMovieApp
//
//  Created by Ernesto De los Santos Cordero on 9/27/18.
//  Copyright © 2018 BananaLabs. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHelper {
    
    private static var instance: CoreDataHelper?;
    public var manageContext: NSManagedObjectContext;
    
    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.manageContext = appDelegate.persistentContainer.viewContext
    }
    
    public static func getInstance() -> CoreDataHelper {
        if instance == nil {
            instance = CoreDataHelper()
        }
        return instance!
    }
}

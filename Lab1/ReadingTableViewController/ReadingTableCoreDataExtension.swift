//
//  ReadingTableCoreDataExtension.swift
//  Lab1
//
//  Created by Konstantyn Byhkalo on 1/10/17.
//  Copyright © 2017 Dmitriy Gaponenko. All rights reserved.
//

import Foundation
import CoreData

extension ReadingTableViewController: NSFetchedResultsControllerDelegate {
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<Reading> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Reading> = Reading.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "sensor.name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    
}

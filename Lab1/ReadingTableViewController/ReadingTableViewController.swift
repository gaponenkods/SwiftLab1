//
//  ReadingTableViewController.swift
//  Lab1
//
//  Created by Konstantyn Byhkalo on 12/13/16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import UIKit
import CoreData

class ReadingTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var managedObjectContext: NSManagedObjectContext? = AppDelegate.sharedDelegate.persistentContainer.viewContext
    var _fetchedResultsController: NSFetchedResultsController<Reading>? = nil
    
    var db = AppDelegate.sharedDelegate.db
    var _sqliteReadingObjects: [ReadingModelSQL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return self.fetchedResultsController.sections?.count ?? 0
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isCoreDataRun() {
            let sectionInfo = self.fetchedResultsController.sections![section]
            return sectionInfo.numberOfObjects
        } else {
            return sqliteReadingObjects.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        var presentReading: ReadingTableModel!
        if isCoreDataRun() {
            let reading = self.fetchedResultsController.object(at: indexPath)
            presentReading = ReadingTableModel(reading)
        } else {
            let reading = sqliteReadingObjects[indexPath.row]
            presentReading = ReadingTableModel(reading)
        }
        
        self.configureCell(cell!, withReading: presentReading)
        
        return cell!
    }
    
    func configureCell(_ cell: UITableViewCell, withReading reading: ReadingTableModel) {
        cell.textLabel!.text = reading.presentedText()
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Senson #\(section+1)"
//    }
//    
}

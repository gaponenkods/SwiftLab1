//
//  SensorTableViewController.swift
//  Lab1
//
//  Created by Konstantyn Byhkalo on 12/13/16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import UIKit
import CoreData

class SensorTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var managedObjectContext: NSManagedObjectContext? = AppDelegate.sharedDelegate.persistentContainer.viewContext
    var _fetchedResultsController: NSFetchedResultsController<Sensor>? = nil
    
    var db = AppDelegate.sharedDelegate.db
    var _sqliteSensorObjects: [SensorModelSQL] = []
    
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
            return sqliteSensorObjects.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        var presentSensor: SensorTableModel!
        if isCoreDataRun() {
            let sensor = self.fetchedResultsController.object(at: indexPath)
            presentSensor = SensorTableModel(sensor)
        } else {
            let sensor = sqliteSensorObjects[indexPath.row]
            presentSensor = SensorTableModel(sensor)
        }
        
        self.configureCell(cell!, withSensor: presentSensor)
        
        return cell!
    }
    
    func configureCell(_ cell: UITableViewCell, withSensor sensor: SensorTableModel) {
        cell.textLabel!.text = sensor.presentedText()
    }
    
    //    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return "Senson #\(section+1)"
    //    }
    //    

    
}

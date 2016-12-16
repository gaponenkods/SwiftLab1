//
//  UtilityViewController.swift
//  Lab1
//
//  Created by Konstantyn Byhkalo on 12/13/16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import UIKit
import CoreData

class UtilityViewController: UIViewController, NSFetchedResultsControllerDelegate, UITextFieldDelegate {

    var managedObjectContext: NSManagedObjectContext? = AppDelegate.sharedDelegate.persistentContainer.viewContext
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        
        if fetchedResultsController.fetchedObjects?.count != 20 {
            regenerateSensors()
        }
    }
    
    var _fetchedResultsController: NSFetchedResultsController<Sensor>? = nil
    var fetchedResultsController: NSFetchedResultsController<Sensor> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Sensor> = Sensor.fetchRequest()
        
        // Set the batch size to a suitable number.
//        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
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
    
//    MARK: - Help Methods
    
    func regenerateSensors() {
        let context = self.fetchedResultsController.managedObjectContext
        if let objects = fetchedResultsController.fetchedObjects {
            for object in objects {
                context.delete(object)
            }
        }
        AppDelegate.saveContext()
        
        for index in 1...20 {
            print("Index = \(index)")
            let newSensor = Sensor(context: managedObjectContext!)
            newSensor.name = "S\(String(format: "%02d", index))"
            newSensor.sensorDescription = "Sensor number \(index)"
        }
        AppDelegate.saveContext()
    }
    
    func generateRandomReading() -> Reading {
        let context = self.fetchedResultsController.managedObjectContext
        let newReading = Reading(context: context)

        
        let randomNum:Float = Float(arc4random_uniform(100)) // range is 0 to 99
        let randomEnd:Float = Float(arc4random()) / Float(UINT32_MAX)
        let value = randomNum + randomEnd
        
        let randomYearSecond = Int(arc4random_uniform(31556926))
        let randomTimestamp = Date() - TimeInterval(randomYearSecond)
        
        let randomRow = Int(arc4random_uniform(20))
        let randomIndex = IndexPath(row: randomRow, section: 0)
        let randomSensor = fetchedResultsController.object(at: randomIndex)
        
        newReading.sensor = randomSensor
        randomSensor.addToReadings(newReading)
        newReading.value = value
        newReading.timestamp = randomTimestamp as NSDate
        
        return newReading
    }
    
    func startGenerating(count: Int) {
        for _ in 0...count {
            _ = generateRandomReading()
        }
        AppDelegate.saveContext()
        
        let fetchRequestMinValue: NSFetchRequest<Reading> = Reading.fetchRequest()
        let fetchRequestMaxValue: NSFetchRequest<Reading> = Reading.fetchRequest()
        
        fetchRequestMinValue.fetchLimit = 1
        fetchRequestMaxValue.fetchLimit = 1
        
        let sortDescriptionMinValue = NSSortDescriptor(key: "value", ascending: true)
        let sortDescriptionMaxValue = NSSortDescriptor(key: "value", ascending: false)
        
        fetchRequestMinValue.sortDescriptors = [sortDescriptionMinValue]
        fetchRequestMaxValue.sortDescriptors = [sortDescriptionMaxValue]
        
        let recordMinValue = try? (managedObjectContext?.fetch(fetchRequestMinValue))! as [Reading]
        let recordMaxValue = try? (managedObjectContext?.fetch(fetchRequestMaxValue))! as [Reading]
        print("recordMinValue = \(recordMinValue?.first)")
        print("recordMaxValue = \(recordMaxValue?.first)")
        
        
        let expressionDesc = NSExpressionDescription()
        let averageValuesKey = "averageValues"
        expressionDesc.name = averageValuesKey
        expressionDesc.expression = NSExpression(forFunction: "average:",
                                                 arguments:[NSExpression(forKeyPath: "value")])
        expressionDesc.expressionResultType = .floatAttributeType
        
    
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = Reading.fetchRequest()
        fetchRequest.propertiesToFetch = [expressionDesc]
        fetchRequest.resultType = .dictionaryResultType
        
        do {
            let results = try managedObjectContext?.fetch(fetchRequest)
            print(results?.first ?? "averageValue is nil")
        } catch {
            print("fetch failed UtilityViewController.line.146")
        }
        
        
    }
    
//    MARK: - UITextFieldDelegate
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
//    MARK: - Actions
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        guard let count = Int(textField.text!) else {
            return
        }
        
        startGenerating(count: count)
    }
    
    @IBAction func deleteAllButtonAction(_ sender: UIButton) {
        regenerateSensors()
    }
    
    @IBAction func experimentFirstButtonAction(_ sender: UIButton) {
        startGenerating(count: 1000)
    }
    
    @IBAction func experimentSecondButtonAction(_ sender: UIButton) {
        startGenerating(count: 1000000)
    }
    
    
    
}

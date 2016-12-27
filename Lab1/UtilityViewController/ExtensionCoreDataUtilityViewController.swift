//
//  ExtensionCoreDataUtilityViewController.swift
//  Lab1
//
//  Created by Konstantyn Byhkalo on 12/27/16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import Foundation
import CoreData

extension UtilityViewController {
    
    func checkSensorsCountCD() {
        fetchSensors { (sensors) in
            if let sensors = sensors {
                if sensors.count != 20 {
                    regenerateSensorsCD()
                }
            } else {
                regenerateSensorsCD()
            }
        }
    }
    
    //    MARK: - Help Methods
    
    func fetchSensors(returnSensors: ([Sensor]?) -> ()) {
        guard let context = managedObjectContext else {
            print("Context is nil")
            return
        }
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = Sensor.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            returnSensors(results as? [Sensor])
        } catch {
            print("fetch failed UtilityViewController.line.46")
            returnSensors(nil)
        }
    }
    
    func regenerateSensorsCD() {
        
        fetchSensors { (sensors) in
            if let sensors = sensors {
                for object in sensors {
                    managedObjectContext?.delete(object as NSManagedObject)
                }
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
    
    func generateRandomReading() -> Reading? {
        if let context = managedObjectContext {
            let newReading = Reading(context: context)
            
            let randomNum:Float = Float(arc4random_uniform(100)) // range is 0 to 99
            let randomEnd:Float = Float(arc4random()) / Float(UINT32_MAX)
            let value = randomNum + randomEnd
            
            let randomYearSecond = Int(arc4random_uniform(31556926))
            let randomTimestamp = Date() - TimeInterval(randomYearSecond)
            
            let randomSensor = Int(arc4random_uniform(20))+1
            
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = Sensor.fetchRequest()
            let resultPredicate = NSPredicate(format: "name = %@", "S\(String(format: "%02d", randomSensor))")
            fetchRequest.predicate = resultPredicate
            
            do {
                let results = try context.fetch(fetchRequest)
                let randomSensor = results.first as? Sensor
                if let randomSensor = randomSensor {
                    newReading.sensor = randomSensor
                    randomSensor.addToReadings(newReading)
                    newReading.value = value
                    newReading.timestamp = randomTimestamp as NSDate
                    return newReading
                } else {
                    print("fetch failed UtilityViewController.line.99")
                    return nil
                }
            } catch {
                print("fetch failed UtilityViewController.line.103")
                return nil
            }
        }
        return nil
    }
    
    //    MARK: - Generating Method By Count
    
    func startGeneratingCD(count: Int) {
        print("count = \(count)")
        for index in 0...count {
            print("index = \(index)")
            _ = generateRandomReading()
        }
        AppDelegate.saveContext()
        
        findMaxAndMinValues()
        findAvarageValueOfAllReadings()
        findAvarageValueOfReadingsBySensors()
    }
    
    func findMaxAndMinValues() {
        // Maximum and Minimum Values
        func fetchMax(isMax: Bool) {
            let fetchRequestValue: NSFetchRequest<Reading> = Reading.fetchRequest()
            fetchRequestValue.fetchLimit = 1
            let sortDescriptionValue = NSSortDescriptor(key: "value", ascending: !isMax)
            fetchRequestValue.sortDescriptors = [sortDescriptionValue]
            let recordValue = try? (managedObjectContext?.fetch(fetchRequestValue))! as [Reading]
            print("record \(isMax ? "MAX" : "MIN") Value = \(recordValue?.first)")
        }
        fetchMax(isMax: true)
        fetchMax(isMax: false)
    }
    
    func findAvarageValueOfAllReadings() {
        // Avarage Value of all Readings
        
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
    
    func findAvarageValueOfReadingsBySensors() {
        // Avarage Value of Readings By Sensors
        
        for index in 1...20 {
            let sensorName = "S\(String(format: "%02d", index))"
            let expressionDesc = NSExpressionDescription()
            let averageValuesKey = "averageValues"
            expressionDesc.name = averageValuesKey
            expressionDesc.expression = NSExpression(forFunction: "average:",
                                                     arguments:[NSExpression(forKeyPath: "value")])
            expressionDesc.expressionResultType = .floatAttributeType
            
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = Reading.fetchRequest()
            let resultPredicate = NSPredicate(format: "sensor.name = %@", sensorName)
            fetchRequest.predicate = resultPredicate
            fetchRequest.propertiesToFetch = [expressionDesc]
            fetchRequest.resultType = .dictionaryResultType
            
            do {
                let results = try managedObjectContext?.fetch(fetchRequest)
                let dict = results!.first as! Dictionary<String, Float>
                if results?.first != nil {
                    if let helpValue = dict["averageValues"] {
                        let avValue = String(helpValue as Float)
                        print("averageValue = \(avValue) of Sensor - \(sensorName)")
                    } else {
                        print("No Readings in Sensor - \(sensorName)")
                    }
                } else {
                    print("averageValue is nil")
                }
            } catch {
                print("fetch failed UtilityViewController.line.170")
            }
        }
    }
    
}


//
//  ExtensionSQLiteUtilityViewController.swift
//  Lab1
//
//  Created by Konstantyn Byhkalo on 12/27/16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import Foundation
import SQLite

extension UtilityViewController {
    
    func performSQLite3() {
        db.trace { print($0) }
    }
    
    
    
    func checkSensorsCountSQL() {
        
        // CREATE TABLE "users" IF NOT EXISTS -- ...
        do {
            try db.run(SensorTable.table.create(ifNotExists: true) { t in
                t.column(SensorTable.id, primaryKey: true)
                t.column(SensorTable.description, unique: true)
                t.column(SensorTable.name, unique: true)
            })
        } catch {
            myprint("can't create Sensor Table \n Error: \(error)\n\n")
        }
        
        do {
            try db.run(ReadingTable.table.create(ifNotExists: true) { t in
                t.column(ReadingTable.id, primaryKey: true)
                t.column(ReadingTable.timestamp, unique: false)
                t.column(ReadingTable.value, unique: false)
                t.column(ReadingTable.sensorId, unique: false)
            })
        } catch {
            myprint("can't create Sensor Table \n Error: \(error)\n\n")
        }
        
        fetchSensorsSQL { (sensors) in
            if sensors.count != 20 {
                regenerateSensorsSQL()
            }
        }
    }
    
    //    MARK: - Help Methods
    
    func fetchSensorsSQL(returnSensors: ([SensorModelSQL]) -> ()) {
        
        var sensorModels: [SensorModelSQL] = []
        
        do {
            for sensor in try db.prepare(SensorTable.table) {
                sensorModels.append(SensorModelSQL(sensor: sensor))
            }
        } catch {
            myprint("can't get sensors from SensorTable")
        }
        
        returnSensors(sensorModels)
    }
    
    func regenerateSensorsSQL() {
        do {
            myprint("deleting SensorTable")
            try db.run(SensorTable.table.delete())
            myprint("deleting ReadingTable")
            try db.run(ReadingTable.table.delete())
        } catch {
            myprint("deleting failed \nError: \(error)\n\n")
        }
        
        myprint("generate new Sensors Models")
        for index in 1...20 {
            let name = "S\(String(format: "%02d", index))"
            let description = "Sensor number \(index)"
            do {
                _ = try db.run(SensorTable.table.insert(SensorTable.name <- name, SensorTable.description <- description))
//                myprint("inserted id: \(rowid)")
            } catch {
                myprint("insertion failed Index: \(index)\n Error: \(error)\n\n")
            }
        }
    }
    
    func generateRandomReadingSQL() -> ReadingModelSQL? {
        
        let randomNum:Double = Double(arc4random_uniform(100)) // range is 0 to 99
        let randomEnd:Double = Double(arc4random()) / Double(UINT32_MAX)
        let value = randomNum + randomEnd
        
        let randomYearSecond = Int(arc4random_uniform(31556926))
        let randomTimestamp = Date() - TimeInterval(randomYearSecond)
        
        let randomSensor = Int(arc4random_uniform(20))+1
        
        let newReading = ReadingModelSQL(timestamp: Int64(randomTimestamp.timeIntervalSinceReferenceDate), value: value, sensorId: Int64(randomSensor))
        
        do {
            _ = try db.run(ReadingTable.table
                .insert(ReadingTable.sensorId <- newReading.sensorId,
                        ReadingTable.timestamp <- newReading.timestamp,
                        ReadingTable.value <- newReading.value))
        } catch {
            myprint("insertion Reading failed \n Error: \(error)\n\n")
            return nil
        }
        return newReading
    }
    
    func startGeneratingSQL(count: Int) {
        for _ in 0...count {
            _ = generateRandomReadingSQL()
        }
        
        myprint("\n")
        findMaxAndMinValuesSQL()
        myprint("\n")
        findAvarageValueOfAllReadingsSQL()
        myprint("\n")
        findAvarageValueOfReadingsBySensorsSQL()
    }
    
    func findMaxAndMinValuesSQL() {
        func fetchMax(isMax: Bool) {
            let select = isMax ? ReadingTable.value.max : ReadingTable.value.min
            let value = try! db.scalar(ReadingTable.table.select(select)) // -> Int64?
            myprint("record \(isMax ? "MAX" : "MIN") Value = \(NSString(format: "%.4f", value!))")
            
        }
        fetchMax(isMax: true)
        fetchMax(isMax: false)
    }
    
    func findAvarageValueOfAllReadingsSQL() {
        let average = try! db.scalar(ReadingTable.table.select(ReadingTable.value.average))
        myprint("averageValue = \(NSString(format: "%.4f", average!))")
    }
    
    func findAvarageValueOfReadingsBySensorsSQL() {
        for index in 1...20 {
            do {
                let avValue = try db.scalar(ReadingTable.table.filter(ReadingTable.sensorId == Int64(index)).select(ReadingTable.value.average) )
                myprint("averageValue = \(NSString(format: "%.4f", avValue!)) of Sensor - \(index)")
            } catch {
               myprint("fetching average Reading failed \n Error: \(error)\n\n")
            }
        }
    }
    
}

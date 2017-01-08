//
//  ExtensionSQLiteUtilityViewController.swift
//  Lab1
//
//  Created by Konstantyn Byhkalo on 12/27/16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import Foundation

extension UtilityViewController {
    
    func performSQLite3() {
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let dbFilePath = NSURL(fileURLWithPath: docDir).appendingPathComponent("demo.db")?.path
        
        if sqlite3_open(dbFilePath, &db) == SQLITE_OK {
            print("sqlite3 opened successfully")
        } else {
            print("FAIL when try to open sqlite3")
        }
    }
    
    
    
    func checkSensorsCountSQL() {
        fetchSensorsSQL { (sensors) in
            if let sensors = sensors {
                if sensors.count != 20 {
                    regenerateSensorsSQL()
                }
            } else {
                regenerateSensorsSQL()
            }
        }
    }
    
    //    MARK: - Help Methods
    
    func fetchSensorsSQL(returnSensors: ([Sensor]?) -> ()) {
//        A callback (and should) be provided as a closure:
        let selectSQL = "SELECT sensor_id, name, sensorDescription FROM sensors ORDER BY name DESC"
        var error
        sqlite3_exec(db, selectSQL,
                     {_, columnCount, values, columns in
                        print("Next record")
                        for i in 0 ..< Int(columnCount) {
                            let column = String(cString: columns![i]!)
                            let value = String(cString: values![i]!)
                            print(" \(column) = \(value)")
                        }
                        return 0
        }, nil, nil)
        sqlite3_exec(<#T##OpaquePointer!#>, <#T##sql: UnsafePointer<Int8>!##UnsafePointer<Int8>!#>, <#T##callback: ((UnsafeMutableRawPointer?, Int32, UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?, UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?) -> Int32)!##((UnsafeMutableRawPointer?, Int32, UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?, UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?) -> Int32)!##(UnsafeMutableRawPointer?, Int32, UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?, UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?) -> Int32#>, <#T##UnsafeMutableRawPointer!#>, <#T##errmsg: UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>!##UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>!#>)
    }
    
    func regenerateSensorsSQL() {
        //        Delete all sensors
        //        Create sensors again
        //        sensor name =  "S\(String(format: "%02d", index))"
        
//        SELECT name FROM sqlite_master WHERE type='table' AND name='table_name';
        
        let createSensorSQL = "CREATE TABLE sensors " +
            "(sensor_id INTEGER PRIMARY KEY AUTOINCREMENT, " +
            "name VARCHAR(50), " +
            "sensorDescription VARCHAR(50));"
        
        let createReadingSQL = "CREATE TABLE readings " +
            "(reading_id INT AUTO_INCREMENT PRIMARY KEY " +
            "FOREIGN KEY (sensor_id) REFERENCES sensors(sensor_id)" +
            "value DOUBLE, " +
            "timestamp INT);"
        
        sqlite3_exec(db, createSensorSQL, nil, nil, nil)
        
        for index in 1...20 {
            print("Index = \(index)")
            let insertSQL = "INSERT INTO sensors (name, sensorDescription) VALUES ('S\(String(format: "%02d", index))', 'Sensor number \(index)');"
            sqlite3_exec(db, insertSQL, nil, nil, nil)
        }
        
        let stmt: OpaquePointer? = nil
        sqlite3_finalize(stmt)
        
//        var stmt: OpaquePointer? = nil
//        
//        let selectSQL = "SELECT name, age FROM people ORDER BY age DESC;"
//        
//        sqlite3_prepare_v2(db, selectSQL, -1, &stmt, nil)
//        
//        while sqlite3_step(stmt) == SQLITE_ROW {
//            let name = String(cString: sqlite3_column_text(stmt, 0))
//            let age = sqlite3_column_int(stmt, 1)
//            print("A person called \(name) is \(age) years old.")
//        }
//        
//        sqlite3_finalize(stmt)
    }
    
}

//
//  SensorTableSQLExtension.swift
//  Lab1
//
//  Created by Konstantyn Byhkalo on 1/10/17.
//  Copyright © 2017 Dmitriy Gaponenko. All rights reserved.
//

import Foundation
import SQLite

extension SensorTableViewController {
    
    var sqliteSensorObjects: [SensorModelSQL] {
        
        var sensorModels: [SensorModelSQL] = []
        
        do {
            for sensor in try db.prepare(SensorTable.table) {
                sensorModels.append(SensorModelSQL(sensor: sensor))
            }
        } catch {
            print("can't get sensors from SensorTable")
        }
        _sqliteSensorObjects = sensorModels
        return _sqliteSensorObjects
    }
    
    
}

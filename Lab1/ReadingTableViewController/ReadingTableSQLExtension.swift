//
//  ReadingTableSQLExtension.swift
//  Lab1
//
//  Created by Konstantyn Byhkalo on 1/10/17.
//  Copyright © 2017 Dmitriy Gaponenko. All rights reserved.
//

import Foundation
import SQLite

extension ReadingTableViewController {

    var sqliteReadingObjects: [ReadingModelSQL] {
        
        var readingModels: [ReadingModelSQL] = []
        
        do {
            for reading in try db.prepare(ReadingTable.table.order(ReadingTable.sensorId.asc)) {
                readingModels.append(ReadingModelSQL(reading: reading))
            }
        } catch {
            print("can't get readings from ReadingTable")
        }
        _sqliteReadingObjects = readingModels
        return _sqliteReadingObjects
    }

    
}

//
//  ReadingModelSQL.swift
//  Lab1
//
//  Created by Konstantyn Byhkalo on 1/8/17.
//  Copyright © 2017 Dmitriy Gaponenko. All rights reserved.
//

import Foundation
import SQLite

struct ReadingTable {
    static let table = Table("readings")
    
    static let id = Expression<Int64>("reading_id")
    static let timestamp = Expression<Int64>("timestamp")
    static let value = Expression<Double>("name")
    static let sensorId = Expression<Int64>("sensor_id")
}

class ReadingModelSQL {
    
    var readingId: Int64?
    let timestamp: Int64
    let value: Double
    let sensorId: Int64
    
    init(reading: Row) {
        readingId = reading[ReadingTable.id]
        timestamp = reading[ReadingTable.timestamp]
        value = reading[ReadingTable.value]
        sensorId = reading[ReadingTable.sensorId]
    }
    
    init(timestamp: Int64, value: Double, sensorId: Int64) {
        self.timestamp = timestamp
        self.value = value
        self.sensorId = sensorId
    }
    
}

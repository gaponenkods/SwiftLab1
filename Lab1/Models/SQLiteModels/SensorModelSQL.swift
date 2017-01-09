//
//  SensorModelSQL.swift
//  Lab1
//
//  Created by Konstantyn Byhkalo on 1/8/17.
//  Copyright © 2017 Dmitriy Gaponenko. All rights reserved.
//

import Foundation
import SQLite

struct SensorTable {
    static let table = Table("sensors")
    
    static let id = Expression<Int64>("sensor_id")
    static let description = Expression<String>("sensorDescription")
    static let name = Expression<String?>("name")
}

class SensorModelSQL {
    
    let sensorId: Int
    let sensorDescription: String
    let name: String
    
    init(sensor: Row) {
        sensorId = Int(sensor[SensorTable.id])
        sensorDescription = sensor[SensorTable.description]
        name = sensor[SensorTable.name]!
    }
    
}

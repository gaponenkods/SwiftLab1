//
//  ReadingTableModel.swift
//  Lab1
//
//  Created by Konstantyn Byhkalo on 1/10/17.
//  Copyright © 2017 Dmitriy Gaponenko. All rights reserved.
//

import Foundation
import CoreData

class ReadingTableModel {
    
    let timestamp: Int
    let value: Double
    let sensorId: Int
    
    init(timestamp: Int, value: Double, sensorId: Int) {
        self.timestamp = timestamp
        self.value = value
        self.sensorId = sensorId
    }
    
    convenience init(_ reading: Reading) {
//        EXAMPLE sensor.name = "S\(String(format: "%02d", index))"
        if let sensorName = reading.sensor?.name {
            let index = sensorName.index(sensorName.startIndex, offsetBy: 1)
            let sensorIdString = sensorName.substring(from: index)
            let sensorId = Int(sensorIdString)
            self.init(timestamp: Int((reading.timestamp?.timeIntervalSinceReferenceDate)!), value: Double(reading.value), sensorId: sensorId!)
        } else {
            self.init(timestamp: Int((reading.timestamp?.timeIntervalSinceReferenceDate)!), value: Double(reading.value), sensorId: 0)
        }
    }
    
    convenience init(_ reading: ReadingModelSQL) {
        self.init(timestamp: Int(reading.timestamp), value: reading.value, sensorId: Int(reading.sensorId))
    }
    
    func presentedText() -> String {
        return "Sensor - " + "\(sensorId)" + " " + "\(timestamp) value = \(value)"
    }
    
}

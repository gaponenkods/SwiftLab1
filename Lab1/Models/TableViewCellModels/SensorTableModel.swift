//
//  SensorTableModel.swift
//  Lab1
//
//  Created by Konstantyn Byhkalo on 1/10/17.
//  Copyright © 2017 Dmitriy Gaponenko. All rights reserved.
//

import Foundation
import CoreData

class SensorTableModel {
    
    let sensorId: Int
    let sensorDescription: String
    let name: String
    
    init(sensorId: Int, sensorDescription: String, name: String) {
        self.sensorId = sensorId
        self.sensorDescription = sensorDescription
        self.name = name
    }
    
    convenience init(_ sensor: Sensor) {
        //        EXAMPLE sensor.name = "S\(String(format: "%02d", index))"
        
        if let sensorName = sensor.name {
            let index = sensorName.index(sensorName.startIndex, offsetBy: 1)
            let sensorIdString = sensorName.substring(from: index)
            let sensorId = Int(sensorIdString)
            self.init(sensorId: sensorId!, sensorDescription: sensor.sensorDescription!, name: sensor.name!)
        } else {
            self.init(sensorId: 0, sensorDescription: sensor.sensorDescription!, name: sensor.name!)
        }
    }
    
    convenience init(_ sensor: SensorModelSQL) {
        self.init(sensorId: sensor.sensorId, sensorDescription: sensor.sensorDescription, name: sensor.name)
    }
    
    func presentedText() -> String {
        return "Sensor - \(name). Description = \(sensorDescription)"
    }
    
}

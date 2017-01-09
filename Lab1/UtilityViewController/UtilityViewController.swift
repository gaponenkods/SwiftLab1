//
//  UtilityViewController.swift
//  Lab1
//
//  Created by Konstantyn Byhkalo on 12/13/16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import UIKit
import CoreData
import SQLite

class UtilityViewController: UIViewController, UITextFieldDelegate {

    var managedObjectContext: NSManagedObjectContext? = AppDelegate.sharedDelegate.persistentContainer.viewContext
    
    var db = try! Connection("\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!)/db.sqlite3")
    var experimentTime: Date = Date()
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        
        if isCoreDataRun() { checkSensorsCountCD() } else { performSQLite3(); checkSensorsCountSQL() }
    }
    
    func isCoreDataRun() -> Bool {
        return Bundle.main.bundleIdentifier == "Dmitriy-Gaponenko.Lab1"
    }
    
    func startGenerating(count: Int) {
        myprint("\nStart Experiment. Count = \(count)")
        experimentTime = Date()
        myprint("start time = \(experimentTime)")
        
        if isCoreDataRun() { startGeneratingCD(count: count) } else { startGeneratingSQL(count: count) }
        
        let finishTime = Date()
        myprint("\n")
        myprint("start time = \(experimentTime)")
        myprint("finish time = \(finishTime)")
        myprint("time difference = \(finishTime.timeIntervalSinceReferenceDate - experimentTime.timeIntervalSinceReferenceDate)")
    }
    
//    MARK: - Actions
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        guard let count = Int(textField.text!) else {
            return
        }
        startGenerating(count: count)
    }
    
    @IBAction func deleteAllButtonAction(_ sender: UIButton) {
        if isCoreDataRun() { regenerateSensorsCD() } else { regenerateSensorsSQL() }
    }
    
    @IBAction func experimentFirstButtonAction(_ sender: UIButton) {
        startGenerating(count: 1000)
    }
    
    @IBAction func experimentSecondButtonAction(_ sender: UIButton) {
        startGenerating(count: 1000000)
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
    
    //    MARK: - Print Method
    
    func myprint(_ text: String) {
        textView.text = textView.text + "\n" + text
    }
    
}

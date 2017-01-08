//
//  UtilityViewController.swift
//  Lab1
//
//  Created by Konstantyn Byhkalo on 12/13/16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import UIKit
import CoreData

class UtilityViewController: UIViewController, UITextFieldDelegate {

    var managedObjectContext: NSManagedObjectContext? = AppDelegate.sharedDelegate.persistentContainer.viewContext
    var db: OpaquePointer? = nil
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        
        if isCoreDataRun() { checkSensorsCountCD() } else { performSQLite3(); checkSensorsCountSQL() }
    }
    
    func isCoreDataRun() -> Bool {
        return Bundle.main.bundleIdentifier == "Dmitriy-Gaponenko.Lab1"
    }
    
//    MARK: - Actions
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        guard let count = Int(textField.text!) else {
            return
        }
        if isCoreDataRun() { startGeneratingCD(count: count) } else { /*SQLite*/ }
    }
    
    @IBAction func deleteAllButtonAction(_ sender: UIButton) {
        if isCoreDataRun() { regenerateSensorsCD() } else { /*SQLite*/ }
    }
    
    @IBAction func experimentFirstButtonAction(_ sender: UIButton) {
        if isCoreDataRun() { startGeneratingCD(count: 1000) } else { /*SQLite*/ }
    }
    
    @IBAction func experimentSecondButtonAction(_ sender: UIButton) {
        if isCoreDataRun() { startGeneratingCD(count: 1000000) } else { /*SQLite*/ }
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
}

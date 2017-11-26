//
//  PrefsViewController.swift
//  MacSunnySender
//
//  Created by Jan Verrept on 12/09/17.
//  Copyright © 2017 OneClick. All rights reserved.
//

import Cocoa

class PrefsViewController: NSViewController{
    
    @IBOutlet weak var plantIdentifierField: NSTextField!
    @IBOutlet weak var numberOfInvertersField: NSTextField!
    
    @IBAction func closePrefsWindow(_ sender: NSButton) {
        
        PrefsWindowController.sharedInstance.pVPlantIdentifier = plantIdentifierField.stringValue
        PrefsWindowController.sharedInstance.maxNumberOfInvertersInPlant
            = numberOfInvertersField.integerValue
        
        PrefsWindowController.sharedInstance.writePrefs()
       
        view.window?.close()
    }
        
   
    
   
    // Standard ViewController methods
    override func viewWillAppear(){
        
        super.viewWillAppear()
        PrefsWindowController.sharedInstance.readPrefs()
        
        plantIdentifierField.stringValue = PrefsWindowController.sharedInstance.pVPlantIdentifier
        numberOfInvertersField.integerValue = PrefsWindowController.sharedInstance.maxNumberOfInvertersInPlant
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded
        }
    }
    
    
}


//
//  PrefsWindowController.swift
//  MacSunnySender
//
//  Created by Jan Verrept on 8/09/17.
//  Copyright © 2017 OneClick. All rights reserved.
//

import Cocoa


class PrefsWindowController:NSWindowController{
    
    static let storyboardToUse:NSStoryboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Prefs"), bundle: nil)
    static let sharedInstance:PrefsWindowController = storyboardToUse.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "PrefsWindowController")) as! PrefsWindowController
    
    var pVPlantIdentifier:String = ""
    var maxNumberOfInvertersInPlant = 1
    
    public func writePrefs() {        
        UserDefaults.standard.set(pVPlantIdentifier, forKey: "pVPlantIdentifier")
        UserDefaults.standard.set(maxNumberOfInvertersInPlant, forKey: "maxNumberOfInvertersInPlant")
    }
    
    public func readPrefs() {
        pVPlantIdentifier = UserDefaults.standard.string(forKey: "pVPlantIdentifier") ?? ""
        maxNumberOfInvertersInPlant = UserDefaults.standard.integer(forKey: "maxNumberOfInvertersInPlant")
    }
    

    override func windowDidLoad(){
        super.windowDidLoad()
        window?.delegate = self
    }
    
    
}

extension PrefsWindowController: NSWindowDelegate{
    
}

//
//  AppDelegate.swift
//  MacSunnySender
//
//  Created by Jan Verrept on 11/06/17.
//  Copyright © 2017 OneClick. All rights reserved.
//


import Cocoa
import GRDB

typealias Handle = DWORD
let MAXCSTRINGLENGTH:Int = 32

let prefsController = PrefsWindowController()
let sunnyPortalClient = EmailClient.sharedInstance

private let dataFile = Bundle.main.path(forResource: "MacSunnySenderData", ofType: "sqlite")
let dataBaseQueue = try! DatabaseQueue(path: dataFile!)

let debugger = JVDebugger.sharedInstance

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
        
		// Insert code here to initialize your application
		if SMADriver.installDrivers(configFile: "YasdiConfigFile.ini"){
			SMAInverter.createInverters(maxNumberToSearch: PrefsWindowController.sharedInstance.maxNumberOfInvertersInPlant)
		}
		
	}
	
	func applicationWillTerminate(_ aNotification: Notification) {
		
		// Insert code here to tear down your application
		SMADriver.unInstallDrivers()
		yasdiMasterShutdown()
		
	}
	
	func reset() {
		
		//This function completely resets the software.
		// Any currently detected devices are removed.
		//The software is then in a condition much the same as when the function"yasdiMasterInitialize(...)" has just been executed.
		
		yasdiReset()
		
	}
    
    
    @IBAction func showPrefsWindow(sender:Any?){

        PrefsWindowController.sharedInstance.showWindow(sender)

    }
    
}






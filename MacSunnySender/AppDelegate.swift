//
//  AppDelegate.swift
//  MacSunnySender
//
//  Created by Jan Verrept on 11/06/17.
//  Copyright © 2017 OneClick. All rights reserved.
//

import Cocoa
import SQLite

typealias Handle = DWORD

let maxNumberOfInvertersInPlant = 1 // Replace this integer with the number from the preferences window
let MAXCSTRINGLENGTH:Int = 32
let sunnyPortalClient = EmailClient.sharedInstance
let dataFile = Bundle.main.path(forResource: "MacSunnySenderData", ofType: "sqlite")
let model = try! Connection(dataFile!)
let testDb = try! Connection(Bundle.main.path(forResource: "MacSunnySenderTestData", ofType: "sqlite")!)


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		
		// Insert code here to initialize your application
		if SMADriver.installDrivers(configFile: "YasdiConfigFile.ini"){
			SMAinverter.createInverters(maxNumberToSearch: maxNumberOfInvertersInPlant)
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
	
	
	
	
	
	
}






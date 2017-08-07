//
//  AppDelegate.swift
//  MacSunnySender
//
//  Created by Jan Verrept on 11/06/17.
//  Copyright © 2017 OneClick. All rights reserved.
//

import Cocoa

let MAXSTRINGLENGTH:Int = 32
typealias Handle = DWORD

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		
		// Insert code here to initialize your application
		if SMADriver.installDrivers(configFile: "YasdiConfigFile.ini"){
			SMAinverter.createInverters(maxNumberToSearch: 1) // Replace this integer with the number from the preferences window
		}
		
	}
	
	func applicationWillTerminate(_ aNotification: Notification) {
		
		// Insert code here to tear down your application
		yasdiMasterShutdown()
		
	}
	
	func reset() {
		
		//This function completely resets the software.
		// Any currently detected devices are removed.
		//The software is then in a condition much the same as when the function"yasdiMasterInitialize(...)" has just been executed.
		
		yasdiReset()
		
	}
	
	
	
	
	
	
}






//
//  ViewController.swift
//  MacSunnySender
//
//  Created by Jan Verrept on 7/08/17.
//  Copyright © 2017 OneClick. All rights reserved.
//



import Cocoa

class ViewController: NSViewController {
	
	let appDelegate = NSApplication.shared.delegate as! AppDelegate
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
	}
	
	override var representedObject: Any? {
		didSet {
			// Update the view, if already loaded.
		}
	}
	
	
	@IBAction func testCode(sender:NSButton){
		
		let emailClient = EmailClient.sharedInstance
		emailClient.sendDataToSunnyPortal(inverter:SMAinverter.inverters[0].deviceInfo["Number"])
		
	}
	
}


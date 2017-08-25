//
//  ViewController.swift
//  MacSunnySender
//
//  Created by Jan Verrept on 7/08/17.
//  Copyright © 2017 OneClick. All rights reserved.
//



import Cocoa

class ViewController: NSViewController, NSWindowDelegate {
	
	var associatedDocument:Document?{
		get{
			return (view.window?.windowController?.document as! Document)
		}
	}
	
	var inverter:SMAinverter?{
		get{
			return associatedDocument?.inverter
		}
	}
	
	// Window delegate functions
	// Connect the associated inverter
	func windowDidBecomeKey(_ notification: Notification) {
		updateData()
	}
	
	func updateData(){
		if let inverterName = inverter?.deviceInfo["Name"]{
			view.window?.title = inverterName as! String
		}
	}
	
	
	
	
	
	// Standard ViewController methods
	
	override func viewWillAppear(){
		super.viewWillAppear()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}
	
	override func viewDidAppear() {
		self.view.window?.delegate = self
	}
	
	override var representedObject: Any? {
		didSet {
			// Update the view, if already loaded
		}
	}
	
	
	
	// Test methods
	@IBAction func testCode(sender:NSButton){
		
		//		let emailClient = EmailClient.sharedInstance
		//		emailClient.sendDataToSunnyPortal(inverter:SMAinverter.inverters[0])
		
	}
	
}


//
//  EmailClient.swift
//  MacSunnySender
//
//  Created by Jan Verrept on 19/08/17.
//  Copyright © 2017 OneClick. All rights reserved.
//

import Foundation
import Cocoa


class EmailClient{
	
	static let sharedInstance:EmailClient = EmailClient()
	
	func sendDeviceSpecsToSunnyPortal(inverter:SMAinverter){
		
		// To be repace by the date of the spotvalues timestamp
		let date = Date()
		let formatter = DateFormatter()
		formatter.dateFormat = "MM/dd/yyyy"
		let currentDateString = formatter.string(from: date)
		let deviceSpecificationFile = Bundle.main.url(forResource: nil, withExtension: "dti") as Any
		
		
		// Yet to implement this functionality		
		
		let emailService        = NSSharingService(named: NSSharingService.Name.composeEmail)!
		#if DEBUG
			emailService.recipients = ["janverrept@me.com"]
		#else
			emailService.recipients = ["datacenter@sunny-portal.de"]
		#endif
		emailService.subject    = "SUNNY-MAIL "+currentDateString+"..."
		
		let emailBody           = "This mail was send automatically by Sunny Data Control 3.9.3.4. Please do not reply..."
		let emailAttachment:Any = deviceSpecificationFile
		
		
		if emailService.canPerform(withItems: [emailBody, emailAttachment]) {
			emailService.perform(withItems: [emailBody, emailAttachment])
		} else {
			// email cannot be sent, perhaps no email client is set up
			// Show alert with email address and instructions
		}
		
	}

	
	func sendDataToSunnyPortal(inverter:SMAinverter){
		
		// To be repace by the date of the spotvalues timestamp
		let date = Date()
		let formatter = DateFormatter()
		formatter.dateFormat = "MM/dd/yyyy"
		let currentDateString = formatter.string(from: date)
		
		// Yet to implement this functionality
		let pVPlantIdentifier = "OnsNestje" // Replace this String with the name from the preferences window
		
		
		let emailService        = NSSharingService(named: NSSharingService.Name.composeEmail)!
		#if DEBUG
			emailService.recipients = ["janverrept@me.com"]
		#else
			emailService.recipients = ["datacenter@sunny-portal.de"]
		#endif
		emailService.subject    = "SUNNY-MAIL "+currentDateString+"..."

		let emailBody           = "This mail was send automatically by Sunny Data Control 3.9.3.4. Please do not reply..."
		let emailAttachment:Any = "The actual CSV-file"
		
		
		if emailService.canPerform(withItems: [emailBody, emailAttachment]) {
			emailService.perform(withItems: [emailBody, emailAttachment])
		} else {
			// email cannot be sent, perhaps no email client is set up
			// Show alert with email address and instructions
		}
		
	}
	
}

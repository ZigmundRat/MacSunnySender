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
	
	func sendDataToSunnyPortal(inverter:SMAinverter){
		
		// Yet to implement this functionality
		let pVPlantIdentifier = "OnsNestje" // Replace this String with the name from the preferences window
		
		#if DEBUG
			let emailRecipient = "janverrept@me.com"
		#else
			let emailRecipient = "datacenter@sunny-portal.de"
		#endif
		
		let emailBody           = "Testvalues"
		let emailService        = NSSharingService(named: NSSharingService.Name.composeEmail)!
		emailService.recipients = [emailRecipient]
		emailService.subject    = pVPlantIdentifier
		
		if emailService.canPerform(withItems: [emailBody]) {
			emailService.perform(withItems: [emailBody])
		} else {
			// email cannot be sent, perhaps no email client is set up
			// Show alert with email address and instructions
		}
		
	}
	
}

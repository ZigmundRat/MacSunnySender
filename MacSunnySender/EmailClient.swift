//
//  EmailClient.swift
//  MacSunnySender
//
//  Created by Jan Verrept on 19/08/17.
//  Copyright © 2017 OneClick. All rights reserved.
//

import Cocoa

class EmailClient{
    
    static let sharedInstance:EmailClient = EmailClient()
    
    let pVPlantIdentifier = PrefsWindowController.sharedInstance.pVPlantIdentifier
    var emailSheduler: Timer! = nil
    var lastTimeMailWasSend:Date? = nil
    
    init(){
        
        emailSheduler = Timer.scheduledTimer(timeInterval: 5,
                                              target: self,
                                              selector: #selector(self.sendDataToSunnyPortal),
                                              userInfo: nil,
                                              repeats: true
        )
        
    }
    
    @objc private func sendDataToSunnyPortal(){
        
        let systemTimeStamp = Date()
        let currentLocalHour = Calendar.current.component(Calendar.Component.hour, from: systemTimeStamp)
        
        // Only record dat between 06:00 and 22:59
        if (currentLocalHour == 23) && (lastTimeMailWasSend == nil){
            
            // To be replaced by the date of the spotvalues timestamp
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            let currentDateString = formatter.string(from: date)
            
            
            
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
                lastTimeMailWasSend = Date()
            } else {
                // email cannot be sent, perhaps no email client is set up
                // Show alert with email address and instructions
            }
            
        }else if (currentLocalHour == 00) && (lastTimeMailWasSend != nil){
            
            lastTimeMailWasSend = nil
            
        }
        
        //    private func csvFile(forDate dateQueried: String){
        //
        ////        var CSVSource = """
        ////        SUNNY-MAIL
        ////        Version    1.2
        ////        Source    SDC
        ////        Date    08/20/2017
        ////        Language    EN
        ////
        ////        Type    Serialnumber    Channel    Date    DailyValue    10:47:06    11:02:06
        ////"""
        ////
        ////        for measurement in try model.prepare("SMAMeasurement") {
        ////
        ////        }
        ////
        //
        //    }
        
        
        
        //    func sendDeviceSpecsToSunnyPortal(inverter:SMAInverter){
        //
        //        // To be repace by the date of the spotvalues timestamp
        //        let date = Date()
        //        let formatter = DateFormatter()
        //        formatter.dateFormat = "MM/dd/yyyy"
        //        let currentDateString = formatter.string(from: date)
        //        let deviceSpecificationFile = Bundle.main.url(forResource: nil, withExtension: "dti") as Any
        //
        //
        //        // Yet to implement this functionality
        //
        //        let emailService        = NSSharingService(named: NSSharingService.Name.composeEmail)!
        //        #if DEBUG
        //            emailService.recipients = ["janverrept@me.com"]
        //        #else
        //            emailService.recipients = ["datacenter@sunny-portal.de"]
        //        #endif
        //        emailService.subject    = "SUNNY-MAIL "+currentDateString+"..."
        //
        //        let emailBody           = "This mail was send automatically by Sunny Data Control 3.9.3.4. Please do not reply..."
        //        let emailAttachment:Any = deviceSpecificationFile
        //
        //
        //        if emailService.canPerform(withItems: [emailBody, emailAttachment]) {
        //            emailService.perform(withItems: [emailBody, emailAttachment])
        //        } else {
        //            // email cannot be sent, perhaps no email client is set up
        //            // Show alert with email address and instructions
        //        }
        //
        //    }
        
    }
}

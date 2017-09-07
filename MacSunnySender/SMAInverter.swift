//
//  SMAInverter.swift
//  MacSunnySender
//
//  Created by Jan Verrept on 24/06/17.
//  Copyright © 2017 OneClick. All rights reserved.
//

import Cocoa

class SMAinverter{
    
    static var inverters:[SMAinverter] = []
    
    
    var deviceInfo:SMAInverter!
    var parameterNumbers:[Int]! = []
    var channelNumbers:[Int]! = []
    
    var pollingTimer: Timer? = nil
    
    let sqlTimeStampFormatter = DateFormatter()
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    
    class func createInverters(maxNumberToSearch maxNumber:Int){
        if let devices:[Handle] = searchDevices(maxNumberToSearch:maxNumber){
            for device in devices{
                let newInverter = SMAinverter(device)
                inverters.append(newInverter)
                NSDocumentController.shared.addDocument(Document())
            }
        }
    }
    
    class private func searchDevices(maxNumberToSearch maxNumber:Int)->[Handle]?{
        
        var devices:[Handle]? = nil
        
        let errorCode:Int32 = -1
        var resultCode:Int32 = errorCode
        
        resultCode = DoStartDeviceDetection(CInt(maxNumber), 1);
        
        if resultCode != errorCode {
            
            let errorCode:DWORD = 0
            var resultCode:DWORD = errorCode
            
            let deviceHandles:UnsafeMutablePointer<Handle> = UnsafeMutablePointer<Handle>.allocate(capacity:maxNumber)
            resultCode = GetDeviceHandles(deviceHandles, DWORD(maxNumber))
            if resultCode != errorCode {
                
                // convert to a swift array of devicehandles
                devices = []
                let numberOfDevices = resultCode
                for _ in 0..<numberOfDevices{
                    devices!.append(deviceHandles.pointee)
                    _ = deviceHandles.advanced(by: 1)
                }
            }
        }
        
        return devices
    }
    
    init(_ device:Handle){
        
        sqlTimeStampFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // GMT date string in SQL-format
        dateFormatter.dateFormat = "yyyy-MM-dd" // Local date string
        dateFormatter.timeZone = TimeZone.current
        timeFormatter.dateFormat = "HH:mm:ss" // Local time string
        timeFormatter.timeZone = TimeZone.current
        
        setDeviceInfo(device)
        findParameterNumbers(maxNumberToSearch:30)
        findChannelNumbers(maxNumberToSearch:30)
        
        pollingTimer = Timer.scheduledTimer(timeInterval: 5,
                                            target: self,
                                            selector: #selector(self.readChannels),
                                            userInfo: nil,
                                            repeats: true
        )
        
        print("✅ Inverter \(deviceInfo.name) found online")
        
        
    }
    
    
    
    private func setDeviceInfo(_ device:Handle){
        
        var deviceSN:DWORD = 2000814023
        var deviceName:String = "WR46A-01 SN:2000814023"
        var deviceType:String = "WR46A-01"
        
        let errorCode:Int32 = -1
        var resultCode:Int32 = errorCode
        
        let deviceSNvar: UnsafeMutablePointer<DWORD> = UnsafeMutablePointer<DWORD>.allocate(capacity: 1)
        resultCode = errorCode
        resultCode = GetDeviceSN(device,
                                 deviceSNvar)
        if resultCode != errorCode {
            deviceSN = deviceSNvar.pointee
        }
        
        let deviceNameVar: UnsafeMutablePointer<CChar> = UnsafeMutablePointer<CChar>.allocate(capacity: MAXCSTRINGLENGTH)
        resultCode = errorCode
        resultCode = GetDeviceName(device,
                                   deviceNameVar,
                                   Int32(MAXCSTRINGLENGTH))
        if resultCode != errorCode {
            deviceName = String(cString:deviceNameVar)
        }
        
        let deviceTypeVar: UnsafeMutablePointer<CChar> = UnsafeMutablePointer<CChar>.allocate(capacity: MAXCSTRINGLENGTH)
        resultCode = errorCode
        resultCode = GetDeviceType(device,
                                   deviceTypeVar,
                                   Int32(MAXCSTRINGLENGTH))
        if resultCode != errorCode {
            deviceType = String(cString: deviceTypeVar)
        }
        
        
        deviceInfo = SMAInverter(
            serial: Int(deviceSN),
            number: device,
            name: deviceName,
            type: deviceType
        )
        
        let _ = JVSQliteRecord(data:deviceInfo!, in:model).upsert(matching: ["serial"])
        
    }
    
    
    
    private func findParameterNumbers(maxNumberToSearch:Int){
        
        let errorCode:DWORD = 0
        var resultCode:DWORD = errorCode
        
        let device = deviceInfo.number
        var parameterHandles:UnsafeMutablePointer<Handle> = UnsafeMutablePointer<Handle>.allocate(capacity: maxNumberToSearch)
        let channelType = TChanType.init(1)
        
        resultCode = GetChannelHandlesEx(device,
                                         parameterHandles,
                                         DWORD(maxNumberToSearch),
                                         channelType
        )
        
        if resultCode != errorCode {
            
            // convert to a swift array of parameterNumbers
            let numberOfParameters = resultCode
            for _ in 0..<numberOfParameters{
                parameterNumbers.append(Int(parameterHandles.pointee))
                parameterHandles = parameterHandles.advanced(by: 1)
            }
            
        }else{
            parameterNumbers = []
        }
    }
    
    private func findChannelNumbers(maxNumberToSearch:Int){
        
        let errorCode:DWORD = 0
        var resultCode:DWORD = errorCode
        
        let device = deviceInfo.number
        var channelHandles:UnsafeMutablePointer<Handle> = UnsafeMutablePointer<Handle>.allocate(capacity: maxNumberToSearch)
        let channelType = TChanType.init(0)
        
        resultCode = GetChannelHandlesEx(device,
                                         channelHandles,
                                         DWORD(maxNumberToSearch),
                                         channelType
        )
        
        if resultCode != errorCode {
            
            // convert to a swift array of parameterNumbers
            let numberOfChannels = resultCode
            
            for _ in 0..<numberOfChannels{
                channelNumbers.append(Int(channelHandles.pointee))
                channelHandles = channelHandles.advanced(by: 1)
            }
            
        }else{
            channelNumbers = []
        }
        
    }
    
    
    
    @objc private func readChannels(){
        
        let systemTimeStamp = Date()
        let currentLocalHour = Calendar.current.component(Calendar.Component.hour, from: systemTimeStamp)
        
        // Only record dat between 06:00 and 23:00
        if (6...23) ~= currentLocalHour{
            
            for channelNumber in channelNumbers{
                
                var recordedTimeStamp = systemTimeStamp
                let onlineTimeStamp = GetChannelValueTimeStamp(Handle(channelNumber), deviceInfo.number)
                if onlineTimeStamp > 0{
                    recordedTimeStamp = Date(timeIntervalSince1970:TimeInterval(onlineTimeStamp))
                }
                
                let errorCode:Int32 = -1
                var resultCode:Int32 = errorCode
                
                let channelName: UnsafeMutablePointer<CChar> = UnsafeMutablePointer<CChar>.allocate(capacity: MAXCSTRINGLENGTH)
                
                resultCode = GetChannelName(
                    DWORD(channelNumber),
                    channelName,
                    DWORD(MAXCSTRINGLENGTH)
                )
                
                if resultCode != errorCode {
                    
                    let device = deviceInfo.number
                    let currentValue:UnsafeMutablePointer<Double> = UnsafeMutablePointer<Double>.allocate(capacity: 1)
                    let currentValueAsText: UnsafeMutablePointer<CChar> = UnsafeMutablePointer<CChar>.allocate(capacity: MAXCSTRINGLENGTH)
                    let maxChannelAgeInSeconds:DWORD = 5
                    
                    GetChannelValue(Handle(channelNumber),
                                    device,
                                    currentValue,
                                    currentValueAsText,
                                    DWORD(MAXCSTRINGLENGTH),
                                    maxChannelAgeInSeconds
                    )
                    
                    
                    let unit: UnsafeMutablePointer<CChar> = UnsafeMutablePointer<CChar>.allocate(capacity: MAXCSTRINGLENGTH)
                    GetChannelUnit(Handle(channelNumber), unit, DWORD(MAXCSTRINGLENGTH))
                    
                    let currentMeasurement = SMAMeasurement(
                        serial: deviceInfo.serial,
                        timeStamp: sqlTimeStampFormatter.string(from: recordedTimeStamp),
                        date: dateFormatter.string(from: recordedTimeStamp),
                        time: timeFormatter.string(from: recordedTimeStamp),
                        name: String(cString: channelName),
                        value: currentValue.pointee,
                        unit: String(cString: unit)
                    )
                    
                    let _ = JVSQliteRecord(data:currentMeasurement, in:model).upsert()
                    
                }
                
            }
            
        }
    }
}

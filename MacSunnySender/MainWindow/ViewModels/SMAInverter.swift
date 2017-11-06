//
//  SMAInverter
//  MacSunnySender
//
//  Created by Jan Verrept on 24/06/17.
//  Copyright © 2017 OneClick. All rights reserved.
//

import Cocoa
import GRDB

protocol InverterViewModel {
    
    var serial: Int?{get}
    var number: Handle?{get}
    var name: String?{get}
    var type: String?{get}
    
    var currentMeasurements:[Measurement]?{get}
}

/// C-callback functions
// Should always be declared global???
var callBackFunctionForYasdiEvents:(TYASDIDetectionSub, UInt32, UInt32)->() = {
    (event: TYASDIDetectionSub, deviceHandle: UInt32, param1: UInt32)->()  in
    
    switch event{
    case YASDI_EVENT_DEVICE_ADDED:
        debugger.log(debugLevel:.message ,"Device \(deviceHandle) added")
    case YASDI_EVENT_DEVICE_REMOVED:
        debugger.log(debugLevel:.message,"Device \(deviceHandle) removed")
    case YASDI_EVENT_DEVICE_SEARCH_END:
        debugger.log(debugLevel:.message,"No more devices found")
    case YASDI_EVENT_DOWNLOAD_CHANLIST:
        debugger.log(debugLevel:.message,"Channels downloaded")
    default:
        debugger.log(debugLevel:.error,"Unkwown event occured during async device detection")
    }
}

class SMAInverter: InverterViewModel{
    
    public static var inverters:[SMAInverter] = []
    public var model:Inverter!
    
    var serial: Int?{return model.serial}
    var number: Handle?{return model.number}
    var name: String?{return model.name}
    var type: String?{return model.type}
    
    public var currentMeasurements:[Measurement]? = nil
    
    private var parameterNumbers:[Int]! = []
    private var channelNumbers:[Int]! = []
    private var pollingTimer: Timer! = nil
    private let sqlTimeStampFormatter = DateFormatter()
    private let dateFormatter = DateFormatter()
    private let timeFormatter = DateFormatter()
    
    private let inverterID:Int? = nil
    private let channelID:Int? = nil
    private let measurementID:Int? = nil

    class func handleAllYasdiEvents(){
        yasdiMasterAddEventListener(&callBackFunctionForYasdiEvents, YASDI_EVENT_DEVICE_DETECTION)
    }
    
    class func createInverters(maxNumberToSearch maxNumber:Int){
        if let devices:[Handle] = searchDevices(maxNumberToSearch:maxNumber){
            for device in devices{
                
                let inverterModel = composeInverterModel(fromDevice:device)
                let inverterViewModel = SMAInverter(model:inverterModel)
                inverterViewModel.inverterID = sqlRecord.lastPrimaryKey()

                inverters.append(inverterViewModel)
                
                // Automaticly create a document for each inverter that was found
                NSDocumentController.shared.addDocument(Document(inverter:inverterViewModel))
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
    
    
    class private func composeInverterModel(fromDevice deviceHandle:Handle)->Inverter{
        
        var deviceSN:DWORD = 2000814023
        var deviceName:String = "WR46A-01 SN:2000814023"
        var deviceType:String = "WR46A-01"
        
        let errorCode:Int32 = -1
        var resultCode:Int32 = errorCode
        
        let deviceSNvar: UnsafeMutablePointer<DWORD> = UnsafeMutablePointer<DWORD>.allocate(capacity: 1)
        resultCode = errorCode
        resultCode = GetDeviceSN(deviceHandle,
                                 deviceSNvar)
        if resultCode != errorCode {
            deviceSN = deviceSNvar.pointee
        }
        
        let deviceNameVar: UnsafeMutablePointer<CChar> = UnsafeMutablePointer<CChar>.allocate(capacity: MAXCSTRINGLENGTH)
        resultCode = errorCode
        resultCode = GetDeviceName(deviceHandle,
                                   deviceNameVar,
                                   Int32(MAXCSTRINGLENGTH))
        if resultCode != errorCode {
            deviceName = String(cString:deviceNameVar)
        }
        
        let deviceTypeVar: UnsafeMutablePointer<CChar> = UnsafeMutablePointer<CChar>.allocate(capacity: MAXCSTRINGLENGTH)
        resultCode = errorCode
        resultCode = GetDeviceType(deviceHandle,
                                   deviceTypeVar,
                                   Int32(MAXCSTRINGLENGTH))
        if resultCode != errorCode {
            deviceType = String(cString: deviceTypeVar)
        }
        
        let inverterRecord = Inverter(
            serial: Int(deviceSN),
            number: deviceHandle,
            name: deviceName,
            type: deviceType
        )
        
        var sqlRecord = JVSQliteRecord(data:inverterRecord, in:dataBaseQueue)
        _ = sqlRecord.changeOrCreateRecord(matchFields: ["serial"])
        
        return inverterRecord
    }
    
    
    init(model: Inverter){
        
        self.model = model
        
        sqlTimeStampFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // GMT date string in SQL-format
        dateFormatter.dateFormat = "dd-MM-yyyy" // Local date string
        dateFormatter.timeZone = TimeZone.current
        timeFormatter.dateFormat = "HH:mm:ss" // Local time string
        timeFormatter.timeZone = TimeZone.current
        
        findParameterNumbers(maxNumberToSearch:30)
        findChannelNumbers(maxNumberToSearch:30)
        
        pollingTimer = Timer.scheduledTimer(timeInterval: 5,
                                            target: self,
                                            selector: #selector(self.readChannels),
                                            userInfo: nil,
                                            repeats: true
        )
        
        print("✅ Inverter \(name!) found online")
        
    }
    
    
    private func findParameterNumbers(maxNumberToSearch:Int){
        
        let errorCode:DWORD = 0
        var resultCode:DWORD = errorCode
        
        let device = model.number!
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
        
        let device = number!
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
        
        // Only record dat between 06:00 and 22:59
        if (6...22) ~= currentLocalHour{
            
            currentMeasurements = []
            
            for channelNumber in channelNumbers{
                
                var recordedTimeStamp = systemTimeStamp
                let onlineTimeStamp = GetChannelValueTimeStamp(Handle(channelNumber), number!)
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
                    
                    let device = model.number!
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
                    
                    let currentChannel = Channel(
                        inverterID: serial,
                        name: String(cString: channelName),
                        unit: String(cString: unit)
                    )
                    var channelRecord = JVSQliteRecord(data:currentChannel, in:dataBaseQueue)
                    _ = channelRecord.changeOrCreateRecord()
                    
                    let currentMeasurement = Measurement(
                        channelID: serial,
                        timeStamp: sqlTimeStampFormatter.string(from: recordedTimeStamp),
                        date: dateFormatter.string(from: recordedTimeStamp),
                        time: timeFormatter.string(from: recordedTimeStamp),
                        value: currentValue.pointee
                    )
                    
                    currentMeasurements?.append(currentMeasurement) // Will be displayed
                    var measurementRecord = JVSQliteRecord(data:currentMeasurement, in:dataBaseQueue)
                    _ = measurementRecord.createRecord()
                    
                }
                
            }
            
        }
        
    }
    
    public func saveCsvFile(forDate dateQueried: String){
        
        var CSVSource = """
                SUNNY-MAIL
                Version    1.2
                Source    SDC
                Date    08/20/2017
                Language    EN
        
                Type    Serialnumber    Channel    Date    DailyValue    10:47:06    11:02:06
        """
        
        let dataSeperator = ";"
        
        if let dataRows = searchData(forDate: Date()){
            let columNamesUsed = ["serial","name","date","value","value","time"]
            var dataString:String
            
            for dataRow in dataRows{
                var dataStrings:[String] = []
                
                for columnName in columNamesUsed{
                    dataString = NSString(data: dataRow.dataNoCopy(named: columnName)!, encoding: String.Encoding.utf8.rawValue)! as String
                    dataStrings.append(dataString)
                }
                CSVSource += dataStrings.joined(separator: dataSeperator)
            }
        }
        print(CSVSource) // replace with saved CSVFile
        
    }
    
    private func searchData(forDate reportDate:Date)->[Row]?{
        
        let searchRequest = Measurement(
            channelID: nil,
            timeStamp: nil,
            date: dateFormatter.string(from: reportDate),
            time: nil,
            value: nil
        )
        
        var dailyRequest = JVSQliteRecord(data:searchRequest, in:dataBaseQueue)
        let dailyRecords = dailyRequest.findRecords()
        return dailyRecords
    }
    
    
}

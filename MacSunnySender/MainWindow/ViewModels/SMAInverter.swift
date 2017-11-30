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
    
    var measurementValues:[Measurement]?{get}
    var parameterValues:[Measurement]?{get}
    var testValues:[Measurement]?{get}
    
}

/// C-callback functions
// Should always be declared global???
var callBackFunctionForYasdiEvents:(TYASDIDetectionSub, UInt32, UInt32)->() = {
    (event: TYASDIDetectionSub, deviceHandle: UInt32, param1: UInt32)->()  in
    
    switch event{
    case YASDI_EVENT_DEVICE_ADDED:
        debugger.log(debugLevel:.Message ,"Device \(deviceHandle) added")
    case YASDI_EVENT_DEVICE_REMOVED:
        debugger.log(debugLevel:.Message,"Device \(deviceHandle) removed")
    case YASDI_EVENT_DEVICE_SEARCH_END:
        debugger.log(debugLevel:.Message,"No more devices found")
    case YASDI_EVENT_DOWNLOAD_CHANLIST:
        debugger.log(debugLevel:.Message,"Channels downloaded")
    default:
        debugger.log(debugLevel:.Error,"Unkwown event occured during async device detection")
    }
}

class SMAInverter: InverterViewModel{
    
    enum ChannelsType:UInt32{
        case spotChannels
        case parameterChannels
        case testChannels
        case allChannels
    }
    
    public static var inverters:[SMAInverter] = []
    public var model:Inverter!
    
    var serial: Int?{return model.serial}
    var number: Handle?{return model.number}
    var name: String?{return model.name}
    var type: String?{return model.type}
    
    public var measurementValues:[Measurement]? = nil // These values will eventually be displayed by the MainViewcontroller
    public var parameterValues:[Measurement]? = nil // These values will eventually be displayed by the parameterViewcontroller
    public var testValues:[Measurement]? = nil // These values will not be displayed for now
    
    private var pollingTimer: Timer! = nil
    
    typealias ID = Int
    private var spotChannels:[Channel] = []
    private var parameterChannels:[Channel] = []
    private var testChannels:[Channel] = []
    
    class func handleAllYasdiEvents(){
        yasdiMasterAddEventListener(&callBackFunctionForYasdiEvents, YASDI_EVENT_DEVICE_DETECTION)
    }
    
    class func createInverters(maxNumberToSearch maxNumber:Int){
        if let devices:[Handle] = searchDevices(maxNumberToSearch:maxNumber){
            for device in devices{
                
                var inverterModel = composeInverterModel(fromDevice:device)
                
                // Archive in SQL and
                // complete the model-class with the PK from the SQlrecord
                var  sqlRecord = JVSQliteRecord(data:inverterModel, in:dataBaseQueue)
                let changedSQLRecords = sqlRecord.changeOrCreateRecord(matchFields: ["serial"])
                inverterModel.inverterID = changedSQLRecords?.first?[0]
                
                let inverterViewModel = SMAInverter(model:inverterModel)
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
            inverterID: nil,
            serial: Int(deviceSN),
            number: deviceHandle,
            name: deviceName,
            type: deviceType
        )
        
        return inverterRecord
    }
    
    
    init(model: Inverter){
        
        self.model = model
        
        // Read all channels just once
        readChannels(maxNumberToSearch: 30, channelType: .allChannels)
        
        // Sample spotvalues at a fixed time interval (30seconds here)
        pollingTimer = Timer.scheduledTimer(timeInterval: 30,
                                            target: self,
                                            selector: #selector(self.readValues),
                                            userInfo: ChannelsType.spotChannels,
                                            repeats: true
        )
        
        print("✅ Inverter \(name!) found online")
        
    }
    
    
    private func readChannels(maxNumberToSearch:Int, channelType:ChannelsType = .allChannels){
        
        var channelTypesToRead = [channelType]
        if channelType == .allChannels{
            channelTypesToRead = [ChannelsType.spotChannels, ChannelsType.parameterChannels, ChannelsType.testChannels]
        }
        for typeToRead in channelTypesToRead{
            
            let errorCode:DWORD = 0
            var resultCode:DWORD = errorCode
            var channelHandles:UnsafeMutablePointer<Handle> = UnsafeMutablePointer<Handle>.allocate(capacity: maxNumberToSearch)
            
            resultCode = GetChannelHandlesEx(number!,
                                             channelHandles,
                                             DWORD(maxNumberToSearch),
                                             TChanType(typeToRead.rawValue)
            )
            
            if resultCode != errorCode {
                let numberOfChannels = resultCode
                
                
                for _ in 0..<numberOfChannels{
                    
                    let channelNumber = Int(channelHandles.pointee)
                    
                    let errorCode:Int32 = -1
                    var resultCode:Int32 = errorCode
                    
                    let channelName: UnsafeMutablePointer<CChar> = UnsafeMutablePointer<CChar>.allocate(capacity: MAXCSTRINGLENGTH)
                    resultCode = GetChannelName(
                        DWORD(channelNumber),
                        channelName,
                        DWORD(MAXCSTRINGLENGTH)
                    )
                    
                    if resultCode != errorCode {
                        
                        let unit: UnsafeMutablePointer<CChar> = UnsafeMutablePointer<CChar>.allocate(capacity: MAXCSTRINGLENGTH)
                        GetChannelUnit(Handle(channelNumber), unit, DWORD(MAXCSTRINGLENGTH))
                        
                        // Create the model
                        var channelRecord = Channel(
                            channelID: nil,
                            type: Int(typeToRead.rawValue),
                            number: channelNumber,
                            name: String(cString: channelName),
                            unit: String(cString: unit),
                            inverterID: model.inverterID
                        )
                        
                        // Archive in SQL and
                        // complete the model-class with the PK from the SQlrecord
                        var sqlRecord = JVSQliteRecord(data:channelRecord, in:dataBaseQueue)
                        let changedSQLRecords = sqlRecord.changeOrCreateRecord(matchFields:["type","name"])
                        channelRecord.channelID = changedSQLRecords?.first?[0]
                        
                        // Divide all channels found by their channeltype
                        switch typeToRead{
                        case .spotChannels:
                            spotChannels.append(channelRecord)
                        case .parameterChannels:
                            parameterChannels.append(channelRecord)
                        case .testChannels:
                            testChannels.append(channelRecord)
                        default:
                            break
                        }
                    }
                    
                    
                    
                    channelHandles = channelHandles.advanced(by: 1)
                }
                
                
                
            }
        }
        
    }
    
    // Callbackfunction for the timer
    @objc private func readValues(timer:Timer){
        
        let channelType = timer.userInfo as! ChannelsType
        
        let sqlTimeStampFormatter = DateFormatter()
        sqlTimeStampFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // GMT date string in SQL-format
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd-MM-yyyy" // Local date string
        
        let timeFormatter = DateFormatter()
        timeFormatter.timeZone = TimeZone.current
        timeFormatter.dateFormat = "HH:mm:ss" // Local time string
        
        let systemTimeStamp = Date()
        let currentLocalHour = Calendar.current.component(Calendar.Component.hour, from: systemTimeStamp)
        
        // Only record dat between 06:00 and 22:59
        if (6...22) ~= currentLocalHour{
            
            var channelTypesToRead = [channelType]
            if channelType == .allChannels{
                channelTypesToRead = [ChannelsType.allChannels, ChannelsType.parameterChannels, ChannelsType.testChannels]
            }
            for typeToRead in channelTypesToRead{
                
                let channelsToRead:[Channel]
                switch  typeToRead{
                case .spotChannels:
                    channelsToRead = spotChannels
                case .parameterChannels:
                    channelsToRead = parameterChannels
                case .testChannels:
                    channelsToRead = testChannels
                default:
                    channelsToRead = spotChannels + parameterChannels + testChannels
                }
                
                var currentValues:[Measurement] = []
                
                for channel in channelsToRead{
                    let channelNumber = channel.number!
                    
                    var recordedTimeStamp = systemTimeStamp
                    let onlineTimeStamp = GetChannelValueTimeStamp(Handle(channelNumber), number!)
                    if onlineTimeStamp > 0{
                        recordedTimeStamp = Date(timeIntervalSince1970:TimeInterval(onlineTimeStamp))
                    }
                    
                    let currentValue:UnsafeMutablePointer<Double> = UnsafeMutablePointer<Double>.allocate(capacity: 1)
                    let currentValueAsText: UnsafeMutablePointer<CChar> = UnsafeMutablePointer<CChar>.allocate(capacity: MAXCSTRINGLENGTH)
                    let maxChannelAgeInSeconds:DWORD = 5
                    
                    let errorCode:Int32 = -1
                    var  resultCode:Int32 = errorCode
                    
                    resultCode = GetChannelValue(Handle(channelNumber),
                                                 number!,
                                                 currentValue,
                                                 currentValueAsText,
                                                 DWORD(MAXCSTRINGLENGTH),
                                                 maxChannelAgeInSeconds
                    )
                    
                    if resultCode != errorCode {
                        
                        // Create the model
                        var measurementRecord = Measurement(
                            measurementID: nil,
                            samplingTime: timeFormatter.string(from: systemTimeStamp),
                            timeStamp: sqlTimeStampFormatter.string(from: recordedTimeStamp),
                            date: dateFormatter.string(from: recordedTimeStamp),
                            time: timeFormatter.string(from: recordedTimeStamp),
                            value: currentValue.pointee,
                            channelID: channel.channelID
                        )
                        
                        // Archive in SQL and
                        // complete the model-class with the PK from the SQlrecord
                        var sqlRecord = JVSQliteRecord(data:measurementRecord, in:dataBaseQueue)
                        let changedSQLRecords = sqlRecord.createRecord()
                        measurementRecord.channelID = changedSQLRecords?.first?[0]
                        
                        currentValues.append(measurementRecord)
                        
                    }
                    
                }
                
                // Divide all channels found, by channeltype
                switch  typeToRead{
                case .spotChannels:
                    measurementValues = currentValues
                case .parameterChannels:
                    parameterValues = currentValues
                case .testChannels:
                    testValues = currentValues
                default:
                    break
                }
                
            }
            
        }
    }
    
    public func saveCsvFile(forDate dateQueried: String){
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd-MM-yyyy" // Local date string
        
        var CSVSource = """
                SUNNY-MAIL
                Version    1.2
                Source    SDC
                Date    01/12/2017
                Language    EN
        
                Type    Serialnumber    Channel    Date    DailyValue    10:47:06    11:02:06
        """
        
        let dataSeperator = ";"
        
        if let dailyRecords = searchData(forDate: Date()){
        let columNamesToReport = ["Type","SerialNumber","Channel","Date","DailyValue","valueColumns"]
            
            if let firstRecordedTime = dateFormatter.date(from: (dailyRecords.first!["samplingTime"])!){
            
                var timeToReport = firstRecordedTime
                
                for record in dailyRecords{
                    let recordedTime = dateFormatter.date(from: (record["samplingTime"])!)
                    
                    if recordedTime?.compare(timeToReport) == ComparisonResult.orderedAscending{
                        // Not there yet
                    }else if recordedTime?.compare(timeToReport) == ComparisonResult.orderedDescending{
                        // Shooting past the interval, point to the next higher interval
                        while recordedTime?.compare(timeToReport) == ComparisonResult.orderedDescending{
                            timeToReport = timeToReport.addingTimeInterval(15*60)
                        }
                        // and give it a second shot
                        if recordedTime?.compare(timeToReport) == ComparisonResult.orderedSame{
                           // recordsToReport.append(record)
                        }
                    }else{
                        // When it was recorded at the exact time-interval
                        // Put the record in the report
                       // recordsToReport.append(record)
                    }
                    
                }
                
            }
        }
        print(CSVSource) // replace with saved CSVFile
        
    }
    
    private func searchData(forDate reportDate:Date)->[Row]?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd-MM-yyyy" // Local date string
        
        let searchRequest = Measurement(
            measurementID: nil,
            samplingTime: nil,
            timeStamp: nil,
            date: dateFormatter.string(from: reportDate),
            time: nil,
            value: nil,
            channelID: nil
        )
        
        var dailyRequest = JVSQliteRecord(data:searchRequest, in:dataBaseQueue)
        
        return dailyRequest.findRecords()
    }
    
    
}

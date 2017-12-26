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
// Should always be declared global as pointer to a named function or to a unnamed closure!!!
typealias deviceCallbackFunctionType = @convention(c) (TYASDIDetectionSub,DWORD,DWORD) -> Void
var deviceCallBackFunction:deviceCallbackFunctionType = {(event: TYASDIDetectionSub, deviceHandle: DWORD, param1: DWORD)->()  in
    
    let inverter = SMAInverter.Inverters.filter{$0.number == deviceHandle}.first
    
    switch event{
    case YASDI_EVENT_DEVICE_ADDED:
        SMAInverter.createInverter(withHandle: deviceHandle)
        if let inverterName = SMAInverter.Inverters.last?.name{
            debugger.log(debugLevel: .Succes, "Inverter \(inverterName) found online")
        }
    case YASDI_EVENT_DEVICE_REMOVED:
        if let inverterName = inverter?.name, let index = SMAInverter.Inverters.index(of:inverter!){
            SMAInverter.Inverters.remove(at:index)
            debugger.log(debugLevel: .Message, "Inverter \(inverterName) was removed")
        }
    case YASDI_EVENT_DEVICE_SEARCH_END:
        debugger.log(debugLevel:.Succes,"All devices found")
    case YASDI_EVENT_DOWNLOAD_CHANLIST:
        if param1 < 100{
            debugger.log(debugLevel:.Message,"\(param1)% of channels downloaded")
        }else{
            debugger.log(debugLevel:.Succes,"All channels downloaded")
            inverter?.startAsyncValueReading()
        }
    default:
        debugger.log(debugLevel:.Error,"Unkwown event occured during async device detection")
    }
    
}

typealias valueCallbackFunctionType =  @convention(c)(DWORD,DWORD,UnsafeMutablePointer<Double>,UnsafeMutablePointer<CChar>,Int) -> Void
var valueCallBackFunction:valueCallbackFunctionType = {(handle:DWORD, dDeviceHandle:DWORD, value:UnsafeMutablePointer<Double>,valueAsText:UnsafeMutablePointer<CChar>,erorrcode:Int)->() in
    
    print("A new value of \(value.pointee) was detected for channel \(handle)")
    
    let inverter = SMAInverter.Inverters.filter{$0.number == dDeviceHandle}.first
    inverter?.processMeasurement(device:dDeviceHandle, channel:handle, value:value.pointee)
}

class SMAInverter: InverterViewModel, Equatable{
    
    static func ==(lhs: SMAInverter, rhs: SMAInverter) -> Bool {
        return (lhs.number == rhs.number) && (lhs.serial == rhs.serial)
    }
    
    typealias ID = Int
    
    enum InverterState:Int{
        case Offline
        case Online
        case Ready
        case Active
    }
    
    enum ChannelsType:UInt32{
        case spotChannels
        case parameterChannels
        case testChannels
        case allChannels
    }
    
    //    public static var DetectionTimer:Timer? = nil
    public static var Inverters:[SMAInverter] = []
    
    public var model:Inverter!
    
    var serial: Int?{return model.serial}
    var number: Handle?{return model.number}
    var name: String?{return model.name}
    var type: String?{return model.type}
    
    public var measurementValues:[Measurement]? = nil // These values will eventually be displayed by the MainViewcontroller
    public var parameterValues:[Measurement]? = nil // These values will eventually be displayed by the parameterViewcontroller
    public var testValues:[Measurement]? = nil // These values will not be displayed for now
    
    private var pollingTimer:Timer? = nil
    private var spotChannels:[Channel] = []
    private var parameterChannels:[Channel] = []
    private var testChannels:[Channel] = []
    
    class public func startAsyncDeviceDetection(maxNumberToSearch:Int){
        
        yasdiMasterAddEventListener(unsafeBitCast(deviceCallBackFunction, to: UnsafeMutableRawPointer.self) , YASDI_EVENT_DEVICE_DETECTION)
        
        var yasdiResultCode:Int32 = -1
        yasdiResultCode = DoStartDeviceDetection(CInt(maxNumberToSearch), 0)
        
        let errorCode = Int(yasdiResultCode)
        switch errorCode {
        case YE_OK:
            debugger.log(debugLevel: .Message, "Device detection started")
        case YE_DEV_DETECT_IN_PROGRESS:
            debugger.log(debugLevel: .Warning, "Device detection is already running...")
        case YE_NOT_ALL_DEVS_FOUND:
            debugger.log(debugLevel: .Error, "Not all devices found...")
        default:
            break
        }
        
        //        DetectionTimer = Timer.startOnMainThread(timeInterval: 30,
        //                                                 target: SMAInverter.self,
        //                                                 selector: #selector(SMAInverter.manageDevices),
        //                                                 userInfo: maxNumberToSearch,
        //                                                 fireDirect: true,
        //                                                 repeats: true)
    }
    
    class public func stopAsyncDeviceDetection(){
        
        var yasdiResultCode:Int32 = -1
        yasdiResultCode = DoStopDeviceDetection()
        
        let errorCode = Int(yasdiResultCode)
        switch errorCode {
        case YE_OK:
            debugger.log(debugLevel: .Message, "Device detection ended")
        default:
            break
        }
        
        yasdiMasterRemEventListener(unsafeBitCast(deviceCallBackFunction, to: UnsafeMutableRawPointer.self) , YASDI_EVENT_DEVICE_DETECTION)
        
        //        DetectionTimer?.invalidate()
        //        DetectionTimer = nil
    }
    
    public func startAsyncValueReading(){
        
        yasdiMasterAddEventListener(unsafeBitCast(valueCallBackFunction, to: UnsafeMutableRawPointer.self) , YASDI_EVENT_CHANNEL_NEW_VALUE)
        //        yasdiMasterAddEventListener(unsafeBitCast(valueCallBackFunction, to: UnsafeMutableRawPointer.self) , YASDI_EVENT_CHANNEL_VALUE_SET)
        
        // Sample spotvalues at a fixed time interval (30seconds here)
        pollingTimer = Timer.startOnMainThread(timeInterval: 1,
                                               target: self,
                                               selector:#selector(readValues),
                                               userInfo: ChannelsType.spotChannels,
                                               fireDirect: true,
                                               repeats: true)
        
    }
    
    public func stopAsyncValueReading(){
        
        yasdiMasterRemEventListener(unsafeBitCast(valueCallBackFunction, to: UnsafeMutableRawPointer.self) , YASDI_EVENT_CHANNEL_NEW_VALUE)
        //        yasdiMasterRemEventListener(unsafeBitCast(valueCallBackFunction, to: UnsafeMutableRawPointer.self) , YASDI_EVENT_CHANNEL_VALUE_SET)
        
        pollingTimer?.invalidate()
        pollingTimer = nil
    }
    
//    @objc class public func manageDevices(timer:Timer){
//        
//        
//        if itsDayTime{
//            
//            // During daytime: try to find the maximum number of Inverters available in the system
//            let maxNumberToSearch = CInt(timer.userInfo as! Int)
//            if Inverters.count < maxNumberToSearch{
//                
//            }
//            
//        }else{
//            
//            // During nightTime: remove all existing devices from the system
//            if SMAInverter.Inverters.count > 0 {
//                for inverter in SMAInverter.Inverters{
//                    if let deviceHandle = inverter.number{
//                        var yasdiResultCode:Int32 = -1
//                        yasdiResultCode = RemoveDevice(deviceHandle)
//                        let errorCode = Int(yasdiResultCode)
//                        switch errorCode {
//                        case YE_NO_ERROR:
//                            break
//                        default:
//                            debugger.log(debugLevel: .Error, "Device \(deviceHandle) couldn't be removed from the system")
//                        }
//                    }
//                }
//            }
//        }
//        
//    }
    
    private class var itsDayTime:Bool{
        
        let timeFormatter = DateFormatter()
        timeFormatter.timeZone = TimeZone.current
        timeFormatter.dateFormat = "HH:mm:ss" // Local time string
        
        let systemTimeStamp = Date()
        let currentLocalHour = Calendar.current.component(Calendar.Component.hour, from: systemTimeStamp)
        
        // Only record dat between 06:00 and 22:59
        return (6...22) ~= currentLocalHour
    }
    
    class func createInverter(withHandle handle:Handle){
        
        var inverterModel = composeInverterModel(fromHandle:handle)
        
        // Archive in SQL and
        // complete the model-class with the PK from the SQlrecord
        var  sqlRecord = JVSQliteRecord(data:inverterModel, in:dataBaseQueue)
        let changedSQLRecords = sqlRecord.changeOrCreateRecord(matchFields: ["serial"])
        inverterModel.inverterID = changedSQLRecords?.first?[0]
        
        let inverterViewModel = SMAInverter(model:inverterModel)
        Inverters.append(inverterViewModel)
        
        // Automaticly create a document for each inverter that was found
        NSDocumentController.shared.addDocument(Document(inverter:inverterViewModel))
        
    }
    
    
    class private func composeInverterModel(fromHandle deviceHandle:Handle)->Inverter{
        
        var deviceSN:DWORD = 2000814023
        var deviceName:String = "WR46A-01 SN:2000814023"
        var deviceType:String = "WR46A-01"
        
        var yasdiResultCode:Int32 = -1
        let deviceSNvar: UnsafeMutablePointer<DWORD> = UnsafeMutablePointer<DWORD>.allocate(capacity: 1)
        yasdiResultCode = GetDeviceSN(deviceHandle,
                                      deviceSNvar)
        if yasdiResultCode >= YE_OK {
            deviceSN = deviceSNvar.pointee
        }
        
        let deviceNameVar: UnsafeMutablePointer<CChar> = UnsafeMutablePointer<CChar>.allocate(capacity: MAXCSTRINGLENGTH)
        yasdiResultCode = GetDeviceName(deviceHandle,
                                        deviceNameVar,
                                        Int32(MAXCSTRINGLENGTH))
        if yasdiResultCode >= YE_OK {
            deviceName = String(cString:deviceNameVar)
        }
        
        let deviceTypeVar: UnsafeMutablePointer<CChar> = UnsafeMutablePointer<CChar>.allocate(capacity: MAXCSTRINGLENGTH)
        yasdiResultCode = GetDeviceType(deviceHandle,
                                        deviceTypeVar,
                                        Int32(MAXCSTRINGLENGTH))
        if yasdiResultCode >= YE_OK {
            deviceType = String(cString: deviceTypeVar)
        }
        
        let inverterRecord:Inverter = Inverter(
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
    }
    
    private func readChannels(maxNumberToSearch:Int, channelType:ChannelsType = .allChannels){
        
        var channelTypesToRead = [channelType]
        if channelType == .allChannels{
            channelTypesToRead = [ChannelsType.spotChannels, ChannelsType.parameterChannels, ChannelsType.testChannels]
        }
        
        for typeToRead in channelTypesToRead{
            
            let channelsForInverter = Channel(
                channelID: nil,
                type: Int(typeToRead.rawValue),
                number: nil,
                name: nil,
                unit: nil,
                inverterID: model.inverterID
            )
            var  findRequest = JVSQliteRecord(data:channelsForInverter, in:dataBaseQueue)
            let  archivedChannels = findRequest.findRecords() ?? []
            
            var yasdiResultCode:DWORD = 0
            var channelHandles:UnsafeMutablePointer<Handle> = UnsafeMutablePointer<Handle>.allocate(capacity: maxNumberToSearch)
            yasdiResultCode = GetChannelHandlesEx(number!,
                                                  channelHandles,
                                                  DWORD(maxNumberToSearch),
                                                  TChanType(typeToRead.rawValue)
            )
            
            if (yasdiResultCode > 0){
                if (yasdiResultCode > archivedChannels.count){
                    let numberOfChannels = yasdiResultCode
                    
                    for _ in 0..<numberOfChannels{
                        
                        let channelNumber = Int(channelHandles.pointee)
                        var yasdiResultCode:Int32 = -1
                        let channelName: UnsafeMutablePointer<CChar> = UnsafeMutablePointer<CChar>.allocate(capacity: MAXCSTRINGLENGTH)
                        yasdiResultCode = GetChannelName(
                            DWORD(channelNumber),
                            channelName,
                            DWORD(MAXCSTRINGLENGTH)
                        )
                        
                        if yasdiResultCode >= YE_OK {
                            
                            let unit: UnsafeMutablePointer<CChar> = UnsafeMutablePointer<CChar>.allocate(capacity: MAXCSTRINGLENGTH)
                            yasdiResultCode = GetChannelUnit(Handle(channelNumber), unit, DWORD(MAXCSTRINGLENGTH))
                            
                            if yasdiResultCode >= YE_OK {
                                
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
                                let changedSQLRecords = sqlRecord.changeOrCreateRecord(matchFields:["inverterID","type","name"])
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
                            }else{
                                debugger.log(debugLevel: .Error, "Error reading the unit of channel \(String(cString: channelName))")
                            }
                            
                        }else{
                            debugger.log(debugLevel: .Error, "Error reading name of channel with number \(channelNumber)")
                        }
                        
                        
                        
                        channelHandles = channelHandles.advanced(by: 1)
                    }
                    
                } else {
                    
                    for sqlRecord in archivedChannels{
                        
                        // Create the model
                        let channelRecord = Channel(
                            channelID: sqlRecord["channelID"],
                            type: sqlRecord["type"],
                            number: sqlRecord["number"],
                            name: sqlRecord["name"],
                            unit: sqlRecord["unit"],
                            inverterID: sqlRecord["inverterID"]
                        )
                        
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
                    
                    startAsyncValueReading()
                }
                
            }else{
                debugger.log(debugLevel: .Error, "Error while searching for channels of type \(typeToRead)")
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
        
        // Only record data between 06:00 and 22:59
        if SMAInverter.itsDayTime{
            
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
                
                for channel in channelsToRead{
                    
                    let inverterNumber = Handle(model.number!)
                    let channelNumber = Handle(channel.number!)
                    let maxChannelAgeInSeconds:DWORD = 5
                    let  yasdiResultCode:Int32 = GetChannelValueAsync(channelNumber,
                                                                      inverterNumber,
                                                                      maxChannelAgeInSeconds)
                    
                    
                    let errorCode = Int(yasdiResultCode)
                    switch errorCode {
                    case YE_OK:
                        debugger.log(debugLevel: .Message, "Start reading a new value from channel \(channelNumber)")
                    case YE_UNKNOWN_HANDLE:
                        break
                    case YE_NO_ACCESS_RIGHTS:
                        break
                    default:
                        break
                    }
                    
                }
            }
        }
    }
    
    fileprivate func processMeasurement(device deviceHandle:Handle, channel channelHandle:Handle, value:Double){
        
        //        let channelType = timer.userInfo as! ChannelsType
        
        let sqlTimeStampFormatter = DateFormatter()
        sqlTimeStampFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // GMT date string in SQL-format
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd-MM-yyyy" // Local date string
        
        let timeFormatter = DateFormatter()
        timeFormatter.timeZone = TimeZone.current
        timeFormatter.dateFormat = "HH:mm:ss" // Local time string
        
        let systemTimeStamp = Date()
        
        var recordedTimeStamp = systemTimeStamp
        let onlineTimeStamp = GetChannelValueTimeStamp(channelHandle, deviceHandle)
        if onlineTimeStamp > 0{
            recordedTimeStamp = Date(timeIntervalSince1970:TimeInterval(onlineTimeStamp))
            
            // Create the model
            var measurementRecord = Measurement(
                measurementID: nil,
                samplingTime: timeFormatter.string(from: systemTimeStamp),
                timeStamp: sqlTimeStampFormatter.string(from: recordedTimeStamp),
                date: dateFormatter.string(from: recordedTimeStamp),
                time: timeFormatter.string(from: recordedTimeStamp),
                value: value,
                channelID: Int(channelHandle)
            )
            
            // Archive in SQL and
            // complete the model-class with the PK from the SQlrecord
            var sqlRecord = JVSQliteRecord(data:measurementRecord, in:dataBaseQueue)
            let changedSQLRecords = sqlRecord.createRecord()
            measurementRecord.channelID = changedSQLRecords?.first?[0]
            
        }else{
            debugger.log(debugLevel: .Error, "Error reading timestamp of channel number \(channelHandle)")
        }
        
        
        
    }
    
}




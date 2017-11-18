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
    
    public var currentMeasurements:[Measurement]? = nil
    private var pollingTimer: Timer! = nil
    
    typealias ID = Int
    private var inverterID:ID? = nil
    private var channelID:ID? = nil
    private let measurementID:ID? = nil
    
    var spotChannelNumbers:[Int] = []
    var parameterChannelNumbers:[Int] = []
    var testChannelNumbers:[Int] = []
    
    class func handleAllYasdiEvents(){
        yasdiMasterAddEventListener(&callBackFunctionForYasdiEvents, YASDI_EVENT_DEVICE_DETECTION)
    }
    
    class func createInverters(maxNumberToSearch maxNumber:Int){
        if let devices:[Handle] = searchDevices(maxNumberToSearch:maxNumber){
            for device in devices{
                
                let inverterModel = composeInverterModel(fromDevice:device)
                let inverterViewModel = SMAInverter(model:inverterModel)
                
                // Archive
                var  sqlRecord = JVSQliteRecord(data:inverterModel, in:dataBaseQueue)
                _ = sqlRecord.changeOrCreateRecord(matchFields: ["serial"])
                
                inverterViewModel.inverterID = sqlRecord.currentPrimaryKey
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
        
        return inverterRecord
    }
    
    
    init(model: Inverter){
        
        self.model = model
        
        readChannels(maxNumberToSearch: 30, channelType: .spotChannels) // For now just read all spotchannels
        
        pollingTimer = Timer.scheduledTimer(timeInterval: 5,
                                            target: self,
                                            selector: #selector(self.readValues),
                                            userInfo: nil,
                                            repeats: true
        )
        
        print("✅ Inverter \(name!) found online")
        
    }
    
    
    private func readChannels(maxNumberToSearch:Int, channelType:ChannelsType = .allChannels){
        
        let baseType:TChanType = TChanType(channelType.rawValue)
        
        let errorCode:DWORD = 0
        var resultCode:DWORD = errorCode
        
        let device = number!
        var channelHandles:UnsafeMutablePointer<Handle> = UnsafeMutablePointer<Handle>.allocate(capacity: maxNumberToSearch)
        
        resultCode = GetChannelHandlesEx(device,
                                         channelHandles,
                                         DWORD(maxNumberToSearch),
                                         baseType
        )
        
        if resultCode != errorCode {
            let numberOfChannels = resultCode
            
            for _ in 0..<numberOfChannels{
                
                let channelNumber = Int(channelHandles.pointee)
                
                //TODO: Finde the channeltype on the inverter just in case channelType-argument was .allchannels
                
                // Divide all channels found by their channeltype
                switch  channelType{
                case .spotChannels:
                    spotChannelNumbers.append(channelNumber)
                case .parameterChannels:
                    parameterChannelNumbers.append(channelNumber)
                case .testChannels:
                    testChannelNumbers.append(channelNumber)
                default:
                    break
                }
                
                
                let errorCode:Int32 = 0
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
                    
                    let channelRecord = Channel(
                        inverterID: inverterID,
                        type: Int(channelType.rawValue),
                        name: String(cString: channelName),
                        unit: String(cString: unit)
                    )
                    
                    var sqlRecord = JVSQliteRecord(data:channelRecord, in:dataBaseQueue)
                    _ = sqlRecord.changeOrCreateRecord(matchFields:["name"])
                    channelID = sqlRecord.currentPrimaryKey
                    
                }
                
                channelHandles = channelHandles.advanced(by: 1)
            }
            
        }
        
        
    }
    
    @objc private func readValues(){
        
        // For now just read the spochannels
        let channelType:ChannelsType = .spotChannels
        let channelsToRead:[Int]
        
        // Divide all channels found by their channeltype
        switch  channelType{
        case .spotChannels:
            channelsToRead = spotChannelNumbers
        case .parameterChannels:
            channelsToRead = parameterChannelNumbers
        case .testChannels:
            channelsToRead = testChannelNumbers
        default:
            channelsToRead = spotChannelNumbers + parameterChannelNumbers + testChannelNumbers
        }
        
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
            
            currentMeasurements = []
            
            for channelNumber in channelsToRead{
                
                var recordedTimeStamp = systemTimeStamp
                let onlineTimeStamp = GetChannelValueTimeStamp(Handle(channelNumber), number!)
                if onlineTimeStamp > 0{
                    recordedTimeStamp = Date(timeIntervalSince1970:TimeInterval(onlineTimeStamp))
                }
                
                
                let device = model.number!
                let currentValue:UnsafeMutablePointer<Double> = UnsafeMutablePointer<Double>.allocate(capacity: 1)
                let currentValueAsText: UnsafeMutablePointer<CChar> = UnsafeMutablePointer<CChar>.allocate(capacity: MAXCSTRINGLENGTH)
                let maxChannelAgeInSeconds:DWORD = 5
                
                let errorCode:Int32 = -1
                var  resultCode:Int32 = errorCode
                
                resultCode = GetChannelValue(Handle(channelNumber),
                                             device,
                                             currentValue,
                                             currentValueAsText,
                                             DWORD(MAXCSTRINGLENGTH),
                                             maxChannelAgeInSeconds
                )
                
                if resultCode != errorCode {
                    
                    let measurementRecord = Measurement(
                        channelID: channelID,
                        timeStamp: sqlTimeStampFormatter.string(from: recordedTimeStamp),
                        date: dateFormatter.string(from: recordedTimeStamp),
                        time: timeFormatter.string(from: recordedTimeStamp),
                        value: currentValue.pointee
                    )
                    var sqlRecord = JVSQliteRecord(data:measurementRecord, in:dataBaseQueue)
                    _ = sqlRecord.createRecord()
                    
                    
                    if channelType == .spotChannels{
                        currentMeasurements?.append(measurementRecord) // Will be displayed by te viewcontroller
                    }
                    
                    
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd-MM-yyyy" // Local date string
        
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

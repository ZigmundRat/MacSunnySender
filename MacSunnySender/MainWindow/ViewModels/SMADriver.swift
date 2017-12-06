//
//  SMADriver.swift
//  MacSunnySender
//
//  Created by Jan Verrept on 23/07/17.
//  Copyright © 2017 OneClick. All rights reserved.
//

import Foundation

class SMADriver{
    
    static var drivers:[SMADriver] = []
    
    enum State:Int {
        case offline = 0
        case online = 1
    }
    
    
    let number:Int
    let name:String
    var state:State
    
    class func installDrivers(configFile:String)->Bool{
        
        if let numberOfDrivers = readTheConfigFile(configFile){
            
            for driverNumber in 0..<numberOfDrivers{
                let driver = SMADriver(driverNumber)
                if !driver.setOnline(){
                    return false
                }
                SMADriver.drivers.append(driver)
            }
            
        }
        return true
    }
    
    class func unInstallDrivers(){
        
        let numberOfDrivers = SMADriver.drivers.count
        
        for driverNumber in 0..<numberOfDrivers{
            let driver = SMADriver(driverNumber)
            driver.setOffline()
        }
        
        
    }
    
    private class func readTheConfigFile(_ configFile:String)->Int?{
        
        let numberOfAvailableDrivers:UnsafeMutablePointer<Handle> = UnsafeMutablePointer<Handle>.allocate(capacity: 1)
        let resultCode:Int32 = yasdiMasterInitialize(configFile, numberOfAvailableDrivers)
        
        if resultCode != -1{
            return Int(numberOfAvailableDrivers.pointee)
        }else{
            debugger.log(debugLevel: .Error, "Inifile '\(configFile)' not found or not readable!")
            return nil
        }
        
    }
    
    
    init(_ number:Int){
        self.number = number
        
        let driverName:UnsafeMutablePointer<CHAR> = UnsafeMutablePointer<CHAR>.allocate(capacity:MAXCSTRINGLENGTH)
        let resultCode:BOOL = yasdiMasterGetDriverName(Handle(number),driverName,DWORD(MAXCSTRINGLENGTH))
        
        if resultCode != 0{
            self.name = String(cString: driverName)
        }else{
            self.name = "Unknown driver"
        }
        
        self.state = State.offline
        
    }
    
    
    private func setOnline()->Bool{
        
        let resultCode:BOOL = yasdiMasterSetDriverOnline(Handle(number))
        
        if resultCode != 0{
            state = State.online
            debugger.log(debugLevel: .Succes, "Driver \(name) is now online")
            return true
        }else{
            state = State.offline
            debugger.log(debugLevel: .Error, "Failed to set driver \(name) online")
            return false
        }
        
    }
    
    private func setOffline(){
        
        yasdiMasterSetDriverOffline(Handle(number))
        state = State.offline
        debugger.log(debugLevel: .Info, "Driver \(name) is back offline")
    }
    
    
}



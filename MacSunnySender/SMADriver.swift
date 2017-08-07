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
	
	private class func readTheConfigFile(_ configFile:String)->Int?{
		
		let errorCode:Int32 = -1
		var resultCode:Int32 = errorCode
		
		let numberOfAvailableDrivers:UnsafeMutablePointer<Handle> = UnsafeMutablePointer<Handle>.allocate(capacity: 1)
		resultCode = yasdiMasterInitialize(configFile, numberOfAvailableDrivers)
		
		if resultCode != errorCode{
			return Int(numberOfAvailableDrivers.pointee)
		}else{
			print("❌ ERROR: Inifile '\(configFile)' not found or not readable!")
			return nil
		}
		
	}
	
	
	init(_ number:Int){
		self.number = number
		
		let errorCode:BOOL = 0
		var resultCode:BOOL = errorCode
		
		let driverName:UnsafeMutablePointer<CHAR> = UnsafeMutablePointer<CHAR>.allocate(capacity:MAXSTRINGLENGTH)
		resultCode = yasdiMasterGetDriverName(Handle(number),driverName,DWORD(MAXSTRINGLENGTH))
		
		if resultCode != errorCode{
			self.name = String(cString: driverName)
		}else{
			self.name = "❌ ERROR: Unknown driver"
		}
		
		self.state = State.offline
		
	}
	
	
	private func setOnline()->Bool{
		
		let errorCode:BOOL = 0
		var resultCode:BOOL = errorCode
		
		resultCode = yasdiMasterSetDriverOnline(Handle(number))
		
		if resultCode != errorCode{
			state = State.online
			print("✅ Driver \(name) is now online")
			return true
		}else{
			state = State.offline
			print("❌ ERROR: Failed to set driver \(name) online")
			return false
		}
		
	}
	
	
}



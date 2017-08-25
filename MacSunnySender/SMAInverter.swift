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
	
	
	var deviceInfo:[String:Any] = [:]
	var parameterNumbers:[Int] = []
	var channelNumbers:[Int] = []
	
	var pollingTimer: Timer? = nil
	var currentMeasurements:[SMAMeasurement] = []
	
	
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
				let numberOfDevices = resultCode
				devices = []
				for _ in 0..<numberOfDevices{
					devices!.append(deviceHandles.pointee)
					_ = deviceHandles.advanced(by: 1)
				}
			}
		}
		
		return devices
	}
	
	init(_ device:Handle){
		
		
		setDeviceInfo(device)
		findParameterNumbers(maxNumberToSearch:30)
		findChannelNumbers(maxNumberToSearch:30)
		
		pollingTimer = Timer.scheduledTimer(timeInterval: 5,
		                                    target: self,
		                                    selector: #selector(self.readChannels),
		                                    userInfo: nil,
		                                    repeats: true
		)
		
		print("✅ Inverter \(deviceInfo["Name"] as! String) found online")

		
	}
	
	private func setDeviceInfo(_ device:Handle){
		
		deviceInfo["Number"] = device
		
		let errorCode:Int32 = -1
		var resultCode:Int32 = errorCode
		
		let deviceName: UnsafeMutablePointer<CChar> = UnsafeMutablePointer<CChar>.allocate(capacity: MAXCSTRINGLENGTH)
		resultCode = errorCode
		resultCode = GetDeviceName(device,
		                           deviceName,
		                           Int32(MAXCSTRINGLENGTH))
		if resultCode != errorCode {
			deviceInfo["Name"] = String(cString:deviceName)
		}
		
		let deviceSN: UnsafeMutablePointer<DWORD> = UnsafeMutablePointer<DWORD>.allocate(capacity: 1)
		resultCode = errorCode
		resultCode = GetDeviceSN(device,
		                         deviceSN)
		if resultCode != errorCode {
			deviceInfo["SN"] = deviceSN.pointee
		}
		
		let deviceType: UnsafeMutablePointer<CChar> = UnsafeMutablePointer<CChar>.allocate(capacity: MAXCSTRINGLENGTH)
		resultCode = errorCode
		resultCode = GetDeviceType(device,
		                           deviceType,
		                           Int32(MAXCSTRINGLENGTH))
		if resultCode != errorCode {
			deviceInfo["Type"] = String(cString: deviceType)
		}
		
	}
	
	
	
	private func findParameterNumbers(maxNumberToSearch:Int){
		
		let errorCode:DWORD = 0
		var resultCode:DWORD = errorCode
		
		let device = deviceInfo["Number"] as! Handle
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
		
		let device = deviceInfo["Number"] as! Handle
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
		
		currentMeasurements = []
		
		for channelNumber in channelNumbers{
			let errorCode:Int32 = -1
			var resultCode:Int32 = errorCode
			
			let channelName: UnsafeMutablePointer<CChar> = UnsafeMutablePointer<CChar>.allocate(capacity: MAXCSTRINGLENGTH)
			
			resultCode = GetChannelName(
				DWORD(channelNumber),
				channelName,
				DWORD(MAXCSTRINGLENGTH)
			)
			
			if resultCode != errorCode {
				
				let device = deviceInfo["Number"] as! Handle
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
					name: String(cString: channelName),
					value: currentValue.pointee,
					unit: String(cString: unit),
					timeStamp: Date()
				)
				
				currentMeasurements.append(currentMeasurement)
				print(currentMeasurement) // Temp Test

				
			}
			
		}
		
		
	}
}

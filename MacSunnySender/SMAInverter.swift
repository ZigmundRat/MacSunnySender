//
//  SMAInverter.swift
//  MacSunnySender
//
//  Created by Jan Verrept on 24/06/17.
//  Copyright © 2017 OneClick. All rights reserved.
//

import Foundation

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
				inverters.append(SMAinverter(device))
			}
		}
	}
	
	class private func searchDevices(maxNumberToSearch maxNumber:Int)->[Handle]?{
		
		let errorCode:DWORD = 0
		var resultCode:DWORD = errorCode
		
		let deviceHandles:UnsafeMutablePointer<Handle> = UnsafeMutablePointer<Handle>.allocate(capacity:maxNumber)
		resultCode = GetDeviceHandles(deviceHandles, DWORD(maxNumber))
		if resultCode != errorCode {
			
			// convert to a swift array of devicehandles
			let numberOfDevices = resultCode
			var devices:[Handle] = []
			for _ in 0..<numberOfDevices{
				devices.append(deviceHandles.pointee)
				_ = deviceHandles.advanced(by: 1)
			}
			return devices
		}else{
			return nil
		}
		
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
		
	}
	
	private func setDeviceInfo(_ device:Handle){
		
		deviceInfo["Number"] = Int(device)
		
		let errorCode:Int32 = -1
		var resultCode:Int32 = errorCode
		
		let deviceName: UnsafeMutablePointer<CChar> = UnsafeMutablePointer<CChar>.allocate(capacity: MAXSTRINGLENGTH)
		resultCode = errorCode
		resultCode = GetDeviceName(device,
		                           deviceName,
		                           Int32(MAXSTRINGLENGTH))
		if resultCode != errorCode {
			deviceInfo["Name"] = deviceName.pointee
		}
		
		let deviceSN: UnsafeMutablePointer<DWORD> = UnsafeMutablePointer<DWORD>.allocate(capacity: 1)
		resultCode = errorCode
		resultCode = GetDeviceSN(device,
		                         deviceSN)
		if resultCode != errorCode {
			deviceInfo["SN"] = deviceSN.pointee
		}
		
		let deviceType: UnsafeMutablePointer<CChar> = UnsafeMutablePointer<CChar>.allocate(capacity: MAXSTRINGLENGTH)
		resultCode = errorCode
		resultCode = GetDeviceType(device,
		                           deviceType,
		                           Int32(MAXSTRINGLENGTH))
		if resultCode != errorCode {
			deviceInfo["Type"] = deviceType.pointee
		}
		
	}
	
	
	
	private func findParameterNumbers(maxNumberToSearch:Int){
		
		let errorCode:DWORD = 0
		var resultCode:DWORD = errorCode
		
		let device = deviceInfo["Number"] as! Handle
		let parameterHandles:UnsafeMutablePointer<Handle> = UnsafeMutablePointer<Handle>.allocate(capacity: maxNumberToSearch)
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
				_ = parameterHandles.advanced(by: 1)
			}
			
		}else{
			parameterNumbers = []
		}
	}
	
	private func findChannelNumbers(maxNumberToSearch:Int){
		
		let errorCode:DWORD = 0
		var resultCode:DWORD = errorCode
		
		let device = deviceInfo["Number"] as! Handle
		let channelHandles:UnsafeMutablePointer<Handle> = UnsafeMutablePointer<Handle>.allocate(capacity: maxNumberToSearch)
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
				_ = channelHandles.advanced(by: 1)
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
			
			let channelName: UnsafeMutablePointer<CChar> = UnsafeMutablePointer<CChar>.allocate(capacity: MAXSTRINGLENGTH)
			
			resultCode = GetChannelName(
				DWORD(channelNumber),
				channelName,
				DWORD(MAXSTRINGLENGTH)
			)
			
			if resultCode != errorCode {
				
				let device = deviceInfo["Number"] as! Handle
				let currentValue:UnsafeMutablePointer<Double> = UnsafeMutablePointer<Double>.allocate(capacity: 1)
				let currentValueAsText: UnsafeMutablePointer<CChar> = UnsafeMutablePointer<CChar>.allocate(capacity: MAXSTRINGLENGTH)
				let maxChannelAgeInSeconds:DWORD = 5
				
				GetChannelValue(Handle(channelNumber),
				                device,
				                currentValue,
				                currentValueAsText,
				                DWORD(MAXSTRINGLENGTH),
				                maxChannelAgeInSeconds
				)
				
				
				let unit: UnsafeMutablePointer<CChar> = UnsafeMutablePointer<CChar>.allocate(capacity: MAXSTRINGLENGTH)
				GetChannelUnit(Handle(channelNumber), unit, DWORD(MAXSTRINGLENGTH))
				
				let currentMeasurement = SMAMeasurement(
					name: String(cString: channelName),
					value: currentValue.pointee,
					unit: String(cString: unit),
					timeStamp: Date()
				)
				
				currentMeasurements.append(currentMeasurement)
				
			}
			
		}
		
	}
}
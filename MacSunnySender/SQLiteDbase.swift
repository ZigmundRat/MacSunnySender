//
//  SQLiteDbase.swift
//  MacSunnySender
//
//  Created by Jan Verrept on 25/08/17.
//  Copyright © 2017 OneClick. All rights reserved.
//

import Foundation
import SQLite

class SQLiteDbase{
	
	let db:Connection
	let sqlDateFormatter = DateFormatter()
	
	
	init(dataPath:String){
		db = try! Connection(dataPath)
		sqlDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
	}
	
	public func addInverter(inverter:SMAinverter){
		
//		var serialField = Expression<Int>("serial")
//		let serialNumber:Int = inverter.deviceInfo["SN"] as! Int
//		let previousEntries = Table("inverter").where(serialField == serialNumber)
//
//
//		if try db.run(previousEntries.update(serialField = serialNumber)) > 0 {
//		} else {
//
//			let insertStmt = try! db.prepare("INSERT INTO inverter (serial) VALUES (?)")
//			try! insertStmt.run(serialNumber)
//
//		}
	}
		
	
	public func addMeasurement(inverter:SMAinverter, data:SMAMeasurement){
		
		let serialNumber:String = String(describing: inverter.deviceInfo["SN"])
		let insertStmt = try! db.prepare("INSERT INTO measurement (serial, timestamp, channelName, value, unit) VALUES (?,?,?,?,?)")
		try! insertStmt.run(serialNumber, sqlDateFormatter.string(from: data.timeStamp), data.name, data.value, data.unit)
		
	}
	
}

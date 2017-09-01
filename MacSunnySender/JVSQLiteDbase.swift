//
//  SQLiteDbase.swift
//  MacSunnySender
//
//  Created by Jan Verrept on 25/08/17.
//  Copyright © 2017 OneClick. All rights reserved.
//

import Foundation
import SQLite

typealias ID = Int


// Define the dbaseRecordCreator as a protocol so it can be attached to any type
protocol dbaseRecordable:fullyExtendable{
	var dataBase:Connection{get set}
	var typeAndTableName:String{get}
	var lastRowID:ID{get}
	var sqlFields:(names:String, placeholders:String, values:String, pairs:String){get}
	func insertRecord()
	func updateRecord(matchConditions:String)
	mutating func toSQLiteRecord(in dataBase:Connection, matchConditions:String?)
	
}

// And add some implementation
extension dbaseRecordable{
	
	var dataBase:Connection {
		get {
			return extensionProperty(key:"dataBase") as! Connection
		}
		set(newValue) {
			extensionProperty(key:"dataBase", value:newValue)
		}
	}
	
	var typeAndTableName:String{
		get{
			return String(describing: type(of: self))
		}
	}
	
	var lastRowID:ID{
		get{
			let sqlString = "SELECT seq FROM sqlite_sequence WHERE name=?"
			let sqlPreparedStatement = try! dataBase.prepare(sqlString)
			try! sqlPreparedStatement.run(typeAndTableName)
			return 0
		}
	}
	
	var sqlFields:(names:String, placeholders:String, values:String, pairs:String){
		get{
			// Return all properties as an array of labels and an array of values
			
			let introSpectionData = Mirror(reflecting: self)
			var propertyNames:[String] = []
			var propertyValues:[String] = []
			var propertyPairs:[String] = []
			
			for case let (propertyName?, propertyValue) in introSpectionData.children{
				let valueString = String(describing:propertyValue)
				propertyNames.append(propertyName)
				propertyValues.append(valueString)
				propertyPairs.append("\(propertyName) = \(valueString)")
			}
			
			let	fieldNames:String = propertyNames.joined(separator: ",")
			let placeholders:String = Array(repeating: "?", count:Int(propertyNames.count)).joined(separator: ",")
			let fieldValues:String = propertyValues.joined(separator: ",")
			let fieldValuePairs:String = propertyPairs.joined(separator: ",")
			
			return (fieldNames, placeholders, fieldValues, fieldValuePairs)
		}
	}
	
	func insertRecord(){
		
		// construct an sqlPreparedStatement with it
		let sqlString = "INSERT INTO \(typeAndTableName) (\(sqlFields.names)) VALUES (\(sqlFields.placeholders))"
		let sqlPreparedStatement = try! dataBase.prepare(sqlString)
		try! sqlPreparedStatement.run(sqlFields.values)
	}
	
	func updateRecord(matchConditions:String){
		
		// construct an sqlPreparedStatement with it
		let sqlString = "UPDATE \(typeAndTableName) \(sqlFields.pairs)) WHERE matchConditions"
		let sqlPreparedStatement = try! dataBase.prepare(sqlString)
		try! sqlPreparedStatement.run(sqlFields.values)
	}
	
	mutating func toSQLiteRecord(in dataBaseConnection:Connection, matchConditions:String? = nil){
		
		dataBase = dataBaseConnection
		
		// This an Update or Insert a.k.a an 'UpSert'
		if let matches = matchConditions{
			updateRecord(matchConditions:matches)
		}
		
	}
	
	
}



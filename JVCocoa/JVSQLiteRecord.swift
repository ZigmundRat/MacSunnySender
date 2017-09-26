//
//  JVSQLiteRecord.swift
//  MacSunnySender
//
//  Created by Jan Verrept on 25/08/17.
//  Copyright © 2017 OneClick. All rights reserved.
//

import Foundation
import GRDB
//import SQLite

typealias ID = Int
typealias DataBase = DatabaseQueue

// This structure get initialized with a struct of some generic type and
// mirrors that struct in the SQLite-database

struct JVSQliteRecord<ModelType>{
    
    let dataStruct:ModelType
    let dataBase:DatabaseQueue
    var matchFields:[String]? = nil
    
    init(data:ModelType, in dataBase:DataBase){
        self.dataStruct = data
        self.dataBase = dataBase
    }
    
    private var typeAndTableName:String{
        get{
            return String(describing: type(of: dataStruct))
        }
    }
    
    
    private var sqlExpressions:(names:String, placeholders:String, pairs:String, values:[String], conditions:String){
        get{
            
            // Return all properties as an array of labels and an array of values
            let introSpectionData = Mirror(reflecting: dataStruct)
            var propertyNames:[String] = []
            var propertyPairs:[String] = []
            var propertyValues:[String] = []
            var propertyMatches:[String] = []
            
            for case let (propertyName?, propertyValue) in introSpectionData.children{
                
                propertyNames.append(propertyName)
                propertyPairs.append("\(propertyName) = ?")
                
                let valueString = String(describing:propertyValue)
                propertyValues.append(valueString)
                
                if let matchNames = matchFields{
                    if matchNames.contains(propertyName){
                        propertyMatches.append("\(propertyName) = \(propertyValue)")
                    }
                }
            }
            
            let	fieldNames:String = propertyNames.joined(separator: ",")
            let placeholders:String = Array(repeating: "?", count:Int(propertyNames.count)).joined(separator: ",")
            let fieldPairs = propertyPairs.joined(separator: ",")
            let fieldValues = propertyValues
            let matchConditions = propertyMatches.joined(separator: " AND ")
            
            return (fieldNames, placeholders, fieldPairs, fieldValues, matchConditions)
        }
    }
    
    public func insert(){
        
        let sqlString = "INSERT INTO \(typeAndTableName) (\(sqlExpressions.names)) VALUES (\(sqlExpressions.placeholders))"
        
        try! dataBase.inDatabase { db in
            let sqlStatement = try db.makeUpdateStatement(sqlString)
            try! sqlStatement.execute(arguments: StatementArguments(sqlExpressions.values))
        }
        
        //        try! dataBase.run(
        //            "INSERT INTO \(typeAndTableName) (\(sqlExpressions.names)) VALUES (\(sqlExpressions.placeholders))",
        //            sqlExpressions.values
        //        )
        
    }
    
    
    public mutating func update(matchFields:[String]){
        
        self.matchFields = matchFields
        let sqlString = "UPDATE \(typeAndTableName) SET \(sqlExpressions.pairs) WHERE \(sqlExpressions.conditions)"
        
        try! dataBase.inDatabase { db in
            let sqlStatement = try db.makeUpdateStatement(sqlString)
            try! sqlStatement.execute(arguments: StatementArguments(sqlExpressions.values))
        }
        
        //        try dataBase.execute(
        //            "UPDATE \(typeAndTableName) SET \(sqlExpressions.pairs) WHERE \(sqlExpressions.conditions)",
        //            sqlExpressions.values
        //        )
        
    }
    
    public mutating func upsert(matchFields:[String]? = nil){
        
        // This an Update or Insert a.k.a an 'UpSert'
        if matchFields == nil{
            insert()
        }else{
            update(matchFields:matchFields!)
        }
        
    }
    
    public mutating func select()->[Row]?{
        
        self.matchFields = sqlExpressions.names.components(separatedBy:  ",")
        let sqlString = "SELECT * FROM \(typeAndTableName) WHERE \(sqlExpressions.conditions)"
        var recordsFound:[Row]? = nil
        
        try! dataBase.inDatabase { db in
            let sqlStatement = try db.makeSelectStatement(sqlString)
            recordsFound = try Row.fetchAll(sqlStatement)
        }
        
        return recordsFound
    }
}



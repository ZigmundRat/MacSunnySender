//
//  JVSQLiteRecord.swift
//  MacSunnySender
//
//  Created by Jan Verrept on 25/08/17.
//  Copyright © 2017 OneClick. All rights reserved.
//

import Foundation
import SQLite

typealias ID = Int

// And add some implementation
class JVSQliteRecord{
    
    let dataStruct:Any
    let dataBase:Connection
    var matchFields:[String]? = nil
    
    init(data:Any, in dataBase:Connection){
        self.dataStruct = data
        self.dataBase = dataBase
    }
    
    private var typeAndTableName:String{
        get{
            return String(describing: type(of: dataStruct))
        }
    }
    
    private var lastRowID:ID{
        get{
            let sqlString = "SELECT seq FROM sqlite_sequence WHERE name=?"
            let sqlPreparedStatement = try! dataBase.prepare(sqlString)
            try! sqlPreparedStatement.run(typeAndTableName)
            return 0
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
        
        try! dataBase.run(
            "INSERT INTO \(typeAndTableName) (\(sqlExpressions.names)) VALUES (\(sqlExpressions.placeholders))",
            sqlExpressions.values
        )
        
    }
    
    public func update(matching exactMatches:[String]){
        matchFields = exactMatches
        try! dataBase.run(
            "UPDATE \(typeAndTableName) SET \(sqlExpressions.pairs) WHERE \(sqlExpressions.conditions)",
            sqlExpressions.values
        )
        
    }
    
    public func upsert(matching exactMatches:[String]? = nil){
        
        // This an Update or Insert a.k.a an 'UpSert'
        if exactMatches == nil{
            insert()
        }else{
            update(matching:exactMatches!)
        }
        
    }
    
    
}



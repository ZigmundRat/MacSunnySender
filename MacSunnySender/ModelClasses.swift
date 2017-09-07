//
//  ModelClasses.swift
//  MacSunnySender
//
//  Created by Jan Verrept on 30/07/17.
//  Copyright © 2017 OneClick. All rights reserved.
//

import Foundation

struct SMAInverter{
	var serial: Int
	var number: Handle
	var name: String
	var type: String
}

struct SMAMeasurement{
	var serial: Int
	var timeStamp:String
	var date: String
	var time: String
	var name: String
	var value: Double
	var unit: String
}

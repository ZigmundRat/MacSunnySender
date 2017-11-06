//
//  Measurement.swift
//  MacSunnySender
//
//  Created by Jan Verrept on 17/09/17.
//  Copyright © 2017 OneClick. All rights reserved.
//

import Foundation

struct Measurement:JVSQliteRecordable{
    var channelID:Int? = nil
    var timeStamp:String? = nil
    var date: String? = nil
    var time: String? = nil
    var value: Double? = nil
}

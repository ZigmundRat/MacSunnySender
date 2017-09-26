//
//  JVArray.swift
//  MacSunnySender
//
//  Created by Jan Verrept on 26/09/17.
//  Copyright © 2017 OneClick. All rights reserved.
//

import Foundation

extension Array {
    
    var firstIndex: Int? {
        return !self.isEmpty ?  0 :  nil
    }
    
    var lastIndex: Int? {
        return !self.isEmpty ? self.endIndex-1 : nil
    }
}

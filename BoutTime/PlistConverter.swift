//
//  PlistConverter.swift
//  BoutTime
//
//  Created by Joshua Borck on 10/3/18.
//  Copyright © 2018 Joshua Borck. All rights reserved.
//

import Foundation

class PlistConverter {
    static func array(fromFile name: String, ofType type: String) throws -> [AnyObject] {
        guard let path = Bundle.main.path(forResource: name, ofType: type) else {
            throw PlistConversionError.missingPlist
        }
        
        guard let array = NSArray(contentsOfFile: path) as [AnyObject]? else {
            throw PlistConversionError.invalidConversion
        }
        
        return array
        
    }
}

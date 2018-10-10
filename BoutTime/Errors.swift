//
//  Errors.swift
//  BoutTime
//
//  Created by Joshua Borck on 10/9/18.
//  Copyright © 2018 Joshua Borck. All rights reserved.
//

import Foundation

enum EventCoverterError: Error {
    case invalidConversion
}

enum PlistConversionError: Error {
    case missingPlist
    case invalidConversion
}

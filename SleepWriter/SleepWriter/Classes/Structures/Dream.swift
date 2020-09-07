//
//  Dream.swift
//  SleepWriter
//
//  Created by Artyom Artamonov on 06.09.2020.
//  Copyright © 2020 Artyom Artamonov. All rights reserved.
//

import Foundation

// Dream structure to save on device
struct Dream : Codable{
    let date : Date
    let title : String
    let text : String
    let last_opened : Date
}

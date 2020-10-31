//
//  Date.swift
//  SleepWriter
//
//  Created by Tamerlan Satualdypov on 29.10.2020.
//  Copyright © 2020 Artyom Artamonov. All rights reserved.
//

import Foundation

extension Date {
    internal func format(to mask : String) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = mask
        dateFormatter.locale = .init(identifier: "ru-RU")
        
        return dateFormatter.string(from: self)
    }
}

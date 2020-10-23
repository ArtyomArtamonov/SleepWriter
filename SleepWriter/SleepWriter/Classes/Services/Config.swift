//
//  Config.swift
//  SleepWriter
//
//  Created by Artyom Artamonov on 13.09.2020.
//  Copyright © 2020 Artyom Artamonov. All rights reserved.
//

import Foundation


let fileName = "sleep_writer_data"

func floatTimeToDateString(since1970: Float) -> String{
    let interval = TimeInterval(since1970)
    let date = Date(timeIntervalSince1970: interval)
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    let dateString = formatter.string(from: date)
    return dateString
}

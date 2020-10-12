//
//  Files.swift
//  SleepWriter
//
//  Created by Artyom Artamonov on 13.09.2020.
//  Copyright © 2020 Artyom Artamonov. All rights reserved.
//

import Foundation
import CoreData

/**
Extension to save/load a JSON object by filename. (".json" extension is assumed and automatically added.)
 */
extension JSONSerialization {
    
    static func loadJSON(withFilename filename: String) throws -> Any? {
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        if let url = urls.first {
            var fileURL = url.appendingPathComponent(filename)
            fileURL = fileURL.appendingPathExtension("json")
            let data = try Data(contentsOf: fileURL)
            let jsonObject = try JSONDecoder().decode([Dream].self, from: data)
            return jsonObject
        }
        return nil
    }
    
    static func save<T : Encodable>(jsonObject: T, toFilename filename: String) throws -> Bool{
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        if let url = urls.first {
            var fileURL = url.appendingPathComponent(filename)
            fileURL = fileURL.appendingPathExtension("json")
            let data = try JSONEncoder().encode(jsonObject)
            try data.write(to: fileURL, options: [.atomicWrite])
            return true
        }
        return false
    }
}

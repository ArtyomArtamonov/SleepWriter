//
//  PersistanceLayer.swift
//  SleepWriter
//
//  Created by Tamerlan Satualdypov on 29.10.2020.
//  Copyright © 2020 Artyom Artamonov. All rights reserved.
//

import Foundation

final class PersistanceLayer {
    public static let coreData : CoreDataManagerProtocol = CoreDataManager()
}

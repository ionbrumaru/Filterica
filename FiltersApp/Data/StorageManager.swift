//
//  DataManager.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 30.07.2020.
//

import RealmSwift
import SwiftUI

public class StorageManager {

    
    static func saveObject (_ filter: filter) {
        try! realmData.write() {
            realmData.add(filter)
        }
    }
    
    static func deleteObject(_ filter: filter) {
        try! realmData.write() {
            realmData.delete(filter)
        }
    }
    
}

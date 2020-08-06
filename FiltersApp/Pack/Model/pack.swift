//
//  pack.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 02.08.2020.
//

import Foundation

import Foundation
import SwiftUI
import RealmSwift

class pack: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    
    @objc dynamic var isFree: Int = 1
    
    convenience init (id: Int, name: String, isFree: Int) {
        self.init()
        self.name = name
        self.id = id
        self.isFree = isFree
    }
}

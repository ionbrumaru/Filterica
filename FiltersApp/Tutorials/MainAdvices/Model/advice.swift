//
//  advice.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 27.12.2020.
//

import Foundation
import SwiftUI
import RealmSwift

class advice: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var text: String = ""
    @objc dynamic var imageName: String = ""
    
    convenience init (id: Int, name: String, text: String, imageName: String) {
        self.init()
        self.name = name
        self.id = id
        self.text = text
        self.imageName = imageName
    }
}

//
//  Filter.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 30.07.2020.
//

import Foundation
import SwiftUI
import RealmSwift

class filter: Object, Codable {
    @objc dynamic var name: String = "Filter-1"
    
    @objc dynamic var tags: String? = "filter"
    @objc dynamic var filterFileUrl: String = ""
    @objc dynamic var imageBefore: String = ""
    @objc dynamic var imageAfter: String = ""
    
    @objc dynamic var settings: imageSettings!
    @objc dynamic var isInPack: String = ""
    @objc dynamic var liked: Bool = false
    
    convenience init (name: String, tags: String?, filterFileURL: String, imageBefore: String, imageAfter: String, filterSettings: imageSettings?, isInPack: String) {
        self.init()
        self.name = name
        self.tags = tags
        self.filterFileUrl = filterFileURL
        self.imageBefore = imageBefore
        self.imageAfter = imageAfter
        self.settings = filterSettings
        self.isInPack = isInPack
    }
}



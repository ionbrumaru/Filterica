//
//  ServerFilter.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 01.08.2020.
//

import Foundation
import SwiftUI
import RealmSwift
class serverFilter: Object {
    @objc dynamic var name: String = "Filter-1"
    @objc dynamic var filterDescription: String = "adds a fantastic blur to image. So gorgeus that you can use it with any type of image even if its black and white"
    
    @objc dynamic var tags: String? = "filter"
    @objc dynamic var filterFileURL: String = ""
    @objc dynamic var imageBefore: String = ""
    @objc dynamic var imageAfter: String = ""
    
    @objc dynamic var filterSettings: imageSettings? = nil
    
    @objc dynamic var isInPack: Int = 0
    
    convenience init (name: String, filterDescription: String, tags: String?, filterFileURL: String, imageBefore: String, imageAfter: String, filterSettings: imageSettings?, isInPack: Int) {
        self.init()
        self.name = name
        self.filterDescription = filterDescription
        self.tags = tags
        self.filterFileURL = filterFileURL
        self.imageBefore = imageBefore
        self.imageAfter = imageAfter
        self.filterSettings = filterSettings
        self.isInPack = isInPack
    }
}


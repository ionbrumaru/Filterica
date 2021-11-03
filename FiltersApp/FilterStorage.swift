//
//  filterStorage.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 07.02.2021.
//


import Foundation
import RealmSwift
import SwiftUI

public class FilterStorage: ObservableObject  {
    
    @Published var filters: [filter] = Array(try! Realm(configuration: Realm.Configuration(schemaVersion: 1)).objects(filter.self))
    
    @Published var packs: [pack] = Array(try! Realm(configuration: Realm.Configuration(schemaVersion: 1)).objects(pack.self))
    
    @Published var isReadyToPresent: Bool = false
    
    var circleCategories: [String] = ["travel", "color", "nature", "urban", "summer"]
    
    var expandableLoad: [String] = ["Porta_PACK","Drake_PACK","Cinematic_PACK","Autumn_PACK","Urban_Life_PACK","Portraits_PACK","atmosphere_filters","Lovely_Autumn_PACK","winter_filters", "color_filters","summer_filter","Night_life_PACK","Moody_PACK","Stay_home_PACK","France_PACK", "neon_filters", "Influencers_PACK","Sun_kissed_PACK","urban_filters","nature_filters", "lights_filters","asia_filters", "DONTDELETE"]
    
    
    
    init() {
    }
}


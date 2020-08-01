//
//  userData.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 30.07.2020.
//

import Foundation
final class UserData: ObservableObject {
    @Published var realm = realmData
    
    @Published var locFilters = localFilters
    
    @Published var servFilters = serverFilters
}


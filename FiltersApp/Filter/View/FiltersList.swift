//
//  FiltersList.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 30.07.2020.
//

import SwiftUI
import RealmSwift
struct FiltersList: View {
    
    
    @State private var filters: [filter] = Array(try! Realm(configuration: Realm.Configuration(schemaVersion: 1)).objects(filter.self))
    
    @State private var packs: [pack] = Array(try! Realm(configuration: Realm.Configuration(schemaVersion: 1)).objects(pack.self))
    
    @State private var selectedFilter: filter?
    
    private var circleCategories: [String] = ["All", "travel", "color", "nature", "urban", "summer", "atmosphere"]
    
    @State private var circleCategoriesFilters: [filter] = []
    
    @State private var categorySelection = 0
    
    //
    private var expandableLoad: [String] = ["urban_filters", "asia_filters", "lights_filters" ,"Portraits_PACK", "neon_filters","nature_filters", "DONTDELETE"]
    @State private var expandableShowHowMany = 0
    @State private var showLoadMoreButton = true
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading) {
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    HStack {
                        Text("Filters")
                            .font(.largeTitle)
                            .bold()
                            .padding(.leading).padding(.top, 8)
                        Spacer()
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {
                            ForEach(0..<6) { counter in
                                FiltersCategory(categoryName: circleCategories[counter], categoryImage: Image(uiImage: UIImage(named: "\(circleCategories[counter])_small")!))
                                    .onTapGesture {
                                        
                                        if (counter != 0)
                                        {
                                            circleCategoriesFilters = filters.filter{ $0.tags!.contains(circleCategories[counter]) }
                                        }
                                        categorySelection = counter
                                    }
                            }
                        }.padding(.leading)
                    }
                    Divider()
                    
                    if (categorySelection == 0) {
                        
                        ShowStaticFilters(filters: $filters, tag: "summer", label: "Summertime")
                        
                        ShowStaticFilters(filters: $filters, tag: "color", label: "Way to colorize")
                        
                        if (packs.count != 0) {
                            ForEach(packs, id: \.self) { serverpack in
                                
                                CategoryTitle(name: serverpack.name, buttonName: "\(filters.filter{ $0.isInPack == serverpack.id  }.count) presets").padding(.top,8)
                                
                                PackPreview(packItem: serverpack, filters: filters.filter{ $0.isInPack == serverpack.id  }, filters_all: $filters).frame( height: 330)
                            }
                            .listItemTint(Color.primary)
                        }
                        
                        ShowStaticFilters(filters: $filters, tag: "atmosphere", label: "Atmosphere")
                        
                        ForEach(0 ..< expandableShowHowMany, id: \.self) { counter1 in
                            
                            if (expandableLoad[counter1].contains("_filters")) {
                                
                                let currentTag = expandableLoad[counter1].replacingOccurrences(of: "_filters", with: "")
                                
                                if filters.filter{ $0.tags!.contains(currentTag) }.count != 0 {
                                    ShowStaticFilters(filters: $filters, tag: currentTag, label: currentTag)
                                }
                                
                            }
                            else if (expandableLoad[counter1].contains("_PACK")) {
                                let pckname = expandableLoad[counter1].replacingOccurrences(of: "_PACK", with: "")
                                let packfiltered = packs.filter{ $0.name.contains(pckname) }
                                
                                if packfiltered.count != 0 {
                                    
                                    let pack = packfiltered[0]
                                    CategoryTitle(name: pckname, buttonName: "\(filters.filter{ $0.isInPack == pack.id  }.count) presets").padding(.top,8)
                                    
                                    PackPreview(packItem: pack, filters: filters.filter{ $0.isInPack == pack.id  }, filters_all: $filters).frame( height: 330)
                                }
                            }
                        }
                        
                        LoadMoreButton(showLoadMoreButton: $showLoadMoreButton, expandableShowHowMany: $expandableShowHowMany, expandableLoad: expandableLoad)
                    }
                    else {
                        
                        OneColumnFiltersView(circleCategories: circleCategories, categorySelection: $categorySelection, circleCategoriesFilters: $circleCategoriesFilters, filters: $filters)
                    }
                    
                }.navigationBarHidden(true)
            }
        }
    }
}

struct CategoryTitle: View {
    var name: String
    var buttonName: String
    var body: some View {
        HStack{
            Text(name.capitalizingFirstLetter())
                .font(.title)
                .bold()
                .padding(.leading)
            
            Spacer()
            
            Text(buttonName).font(.body).foregroundColor(Color(mainColor))
                .padding(.trailing)
        }
    }
}

struct LoadMoreButton: View {
    @Binding var showLoadMoreButton: Bool
    @Binding var expandableShowHowMany: Int
    var expandableLoad: [String]
    var body: some View {
        HStack{
            if showLoadMoreButton {
                Button(action: {
                    //
                    if (expandableShowHowMany + 3 < expandableLoad.count) {
                        expandableShowHowMany += 3
                    }
                    else if (expandableShowHowMany + 2 < expandableLoad.count) {
                        expandableShowHowMany += 2
                    }
                    else if (expandableShowHowMany + 1 < expandableLoad.count) {
                        expandableShowHowMany += 1
                    }
                    else {
                        showLoadMoreButton = false
                    }
                    
                    if (showLoadMoreButton) {
                        if (expandableShowHowMany + 1 == expandableLoad.count) {
                            showLoadMoreButton = false
                        }
                    }
                }) {
                    Text("Load more")
                        .customButton()
                }.padding()
                
            }
        }
    }
}

struct ShowStaticFilters: View {
    @Binding var filters: [filter]
    var tag: String
    var label: String
    var body: some View {
        VStack {
            CategoryTitle(name: label, buttonName: "").padding(.top, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<filters.filter{ $0.tags!.contains(tag) }.count) { counter in
                        NavigationLink(destination: FilterView(filterItem: filters.filter{ $0.tags!.contains(tag) }[counter], filters: $filters, related: filters.filter{ $0.tags!.contains(filters.filter{ $0.tags!.contains(tag) }[counter].tags ?? "nonTag") &&  $0.name != filters.filter{ $0.tags!.contains(tag) }[counter].name })) {
                            FilterPreviewCard(filterItem: filters.filter{ $0.tags!.contains(tag) }[counter])
                        }
                        
                    }
                }.padding().navigationBarTitle("Filters", displayMode: .large)
                
            }.frame(height: 270)
        }
    }
}

struct OneColumnFiltersView: View {
    var circleCategories: [String]
    @Binding var categorySelection: Int
    @Binding var circleCategoriesFilters: [filter]
    @Binding var filters: [filter]
    var body: some View {
        VStack {
            CategoryTitle(name: circleCategories[categorySelection], buttonName: "").padding(.top, 16)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(0..<circleCategoriesFilters.count, id: \.self) { counter in
                        NavigationLink(destination: FilterView(filterItem: circleCategoriesFilters[counter], filters: $filters)) {
                            FilterPreviewCard(filterItem: circleCategoriesFilters[counter]).fixedSize()
                        }
                    }
                }.padding(.leading).padding(.trailing).navigationBarTitle(circleCategories[categorySelection], displayMode: .large)
            }
        }
    }
}

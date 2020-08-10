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
    private var expandableLoad: [String] = ["urban_filters", "nature_filters", "lights_filters" ,"DONTDELETE"]
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
                        
                        CategoryTitle(name: "Summer", buttonName: "").padding(.top, 16)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(0..<filters.filter{ $0.tags!.contains("summer") }.count) { counter in
                                    NavigationLink(destination: FilterView(filterItem: filters.filter{ $0.tags!.contains("summer") }[counter], filters: $filters, related: filters.filter{ $0.tags!.contains(filters.filter{ $0.tags!.contains("summer") }[counter].tags ?? "nonTag") &&  $0.name != filters.filter{ $0.tags!.contains("summer") }[counter].name })) {
                                        FilterPreviewCard(filterItem: filters.filter{ $0.tags!.contains("summer") }[counter])
                                    }
                                    
                                }
                            }.padding().navigationBarTitle("Filters", displayMode: .large)
                            
                        }.frame(height: 270)
                        
                        CategoryTitle(name: "Way to colorize", buttonName: "").padding(.top,8)
                        
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(0..<filters.filter{ $0.tags!.contains("color") }.count) { counter in
                                    NavigationLink(destination: FilterView(filterItem: filters.filter{ $0.tags!.contains("color") }[counter], filters: $filters, related: filters.filter{ $0.tags!.contains(filters.filter{ $0.tags!.contains("color") }[counter].tags ?? "nonTag") &&  $0.name != filters.filter{ $0.tags!.contains("color") }[counter].name })) {
                                        FilterPreviewCard(filterItem: filters.filter{ $0.tags!.contains("color") }[counter])
                                    }
                                }
                            }.padding()
                            
                        }.frame(height: 270)
                        
                        
                        
                        
                        if (packs.count != 0) {
                            ForEach(packs, id: \.self) { serverpack in
                                
                                
                                CategoryTitle(name: serverpack.name, buttonName: "\(filters.filter{ $0.isInPack == serverpack.id  }.count) presets").padding(.top,8)
                                
                                PackPreview(packItem: serverpack, filters: filters.filter{ $0.isInPack == serverpack.id  }, filters_all: $filters).frame( height: 330)
                            }
                            .listItemTint(Color.primary)
                        }
                        
                        CategoryTitle(name: "Atmosphere", buttonName: "").padding(.top,8)
                        
                        
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(0..<filters.filter{ $0.tags!.contains("atmosphere") }.count) { counter in
                                    NavigationLink(destination: FilterView(filterItem: filters.filter{ $0.tags!.contains("atmosphere") }[counter], filters: $filters, related: filters.filter{ $0.tags!.contains(filters.filter{ $0.tags!.contains("atmosphere") }[counter].tags ?? "nonTag") &&  $0.name != filters.filter{ $0.tags!.contains("atmosphere") }[counter].name })) {
                                        FilterPreviewCard(filterItem: filters.filter{ $0.tags!.contains("atmosphere") }[counter])
                                    }
                                }
                            }.padding()
                            
                        }.frame(height: 270)
                        
                        ForEach(0 ..< expandableShowHowMany, id: \.self) { counter1 in
                            
                            if (expandableLoad[counter1].contains("_filters")) {
                                
                                let currentTag = expandableLoad[counter1].replacingOccurrences(of: "_filters", with: "")
                                
                                CategoryTitle(name: currentTag, buttonName: "").padding(.top,8)
                                
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(0..<filters.filter{ $0.tags!.contains(currentTag) }.count, id: \.self) { counter in
                                            NavigationLink(destination: FilterView(filterItem: filters.filter{ $0.tags!.contains(currentTag) }[counter], filters: $filters, related: filters.filter{ $0.tags!.contains(filters.filter{ $0.tags!.contains(currentTag) }[counter].tags ?? "nonTag") &&  $0.name != filters.filter{ $0.tags!.contains(currentTag) }[counter].name })) {
                                                FilterPreviewCard(filterItem: filters.filter{ $0.tags!.contains(currentTag) }[counter])
                                            }
                                        }
                                    }.padding()
                                    
                                }.frame(height: 270)
                                
                            }
                        }
                        
                        
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
                    else {
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
            Text(name)
                .font(.title)
                .bold()
                .padding(.leading)
            
            Spacer()
            
            Text(buttonName).font(.body).foregroundColor(Color(mainColor))
                .padding(.trailing)
        }
    }
}

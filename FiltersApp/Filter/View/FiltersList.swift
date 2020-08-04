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
    
    private var circleCategories: [String] = ["All", "Travel", "Color", "Nature", "Urban", "Summer", "Atmosphere"]
    
    @State private var circleCategoriesFilters: [filter] = []
    

    
    @State private var categorySelection = 0
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading) {
                ScrollView(.vertical, showsIndicators: false) {
                    
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
                    Divider().onAppear() {
                        
                            print(filters)
                        
                    }
                    
                    if (categorySelection == 0) {
                    
                        CategoryTitle(name: "Summer", buttonName: "All").padding(.top, 16)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(0..<filters.filter{ $0.tags!.contains("Summer") }.count) { counter in
                                NavigationLink(destination: FilterView(filterItem: filters.filter{ $0.tags!.contains("Summer") }[counter], filters: $filters, related: filters.filter{ $0.tags!.contains(filters.filter{ $0.tags!.contains("Summer") }[counter].tags ?? "nonTag") &&  $0.name != filters.filter{ $0.tags!.contains("Summer") }[counter].name })) {
                                    FilterPreviewCard(filterItem: filters.filter{ $0.tags!.contains("Summer") }[counter])
                                }
                                
                            }
                        }.padding().navigationBarTitle("Filters", displayMode: .large)
                        
                    }.frame(height: 270)

                    CategoryTitle(name: "Way to colorize", buttonName: "All").padding(.top,8)
                    
                        
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(0..<filters.filter{ $0.tags!.contains("Color") }.count) { counter in
                                NavigationLink(destination: FilterView(filterItem: filters.filter{ $0.tags!.contains("Color") }[counter], filters: $filters, related: filters.filter{ $0.tags!.contains(filters.filter{ $0.tags!.contains("Color") }[counter].tags ?? "nonTag") &&  $0.name != filters.filter{ $0.tags!.contains("Color") }[counter].name })) {
                                    FilterPreviewCard(filterItem: filters.filter{ $0.tags!.contains("Color") }[counter])
                                }   
                            }
                        }.padding()
                        
                    }.frame(height: 270)
                    
                    
                    CategoryTitle(name: "Atmosphere", buttonName: "All").padding(.top,8)
                    
                        
                        
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(0..<filters.filter{ $0.tags!.contains("Atmosphere") }.count) { counter in
                                NavigationLink(destination: FilterView(filterItem: filters.filter{ $0.tags!.contains("Atmosphere") }[counter], filters: $filters, related: filters.filter{ $0.tags!.contains(filters.filter{ $0.tags!.contains("Atmosphere") }[counter].tags ?? "nonTag") &&  $0.name != filters.filter{ $0.tags!.contains("Atmosphere") }[counter].name })) {
                                    FilterPreviewCard(filterItem: filters.filter{ $0.tags!.contains("Atmosphere") }[counter])
                                }
                            }
                        }.padding()
                        
                    }.frame(height: 270)
                     
                        
                        if (packs.count != 0) {
                            ForEach(packs, id: \.self) { serverpack in
                                
                                
                                CategoryTitle(name: serverpack.name, buttonName: "\(filters.filter{ $0.isInPack == packs[0].id  }.count) presets").padding(.top,8)
                                
                                
                                
                                NavigationLink(destination: PackView(filters_all: $filters, packItem: serverpack, filters: filters.filter{ $0.isInPack == packs[0].id })) {
                                    PackPreview(packItem: serverpack, filters: filters.filter{ $0.isInPack == packs[0].id  }).frame( height: 300)
                                }
                                
                                
                                
                            }.listItemTint(Color.primary)
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
    
                }
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
            
            Text(buttonName).font(.body).foregroundColor(Color.primary)
                .padding(.trailing)
        }
    }
}

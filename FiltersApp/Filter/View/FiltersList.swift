//
//  FiltersList.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 30.07.2020.
//

import SwiftUI
import RealmSwift
struct FiltersList: View {
    @EnvironmentObject var userData : UserData
    
    @State private var filters: Results<filter>! = try? Realm(configuration: Realm.Configuration(schemaVersion: 1)).objects(filter.self)
    
    @State private var selectedFilter: filter?
    
    private var circleCategories: [String] = ["All", "Travel", "Color", "Nature", "Urban", "Summer", "Atmosphere"]
    
    @State private var circleCategoriesFilters: [filter] = []
    
    private var summerFilters: [filter] = UserData().child.localFilters.filter{ $0.tags!.contains("Summer") }
    
    private var colorfulFilters: [filter] = UserData().child.localFilters.filter{ $0.tags!.contains("Color") }
    
    private var apmosphereFilters: [filter] = UserData().child.localFilters.filter{ $0.tags!.contains("Atmosphere") }
    
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
                                        
                                            circleCategoriesFilters = userData.child.localFilters.filter{ $0.tags!.contains(circleCategories[counter]) }
                                        }
                                        categorySelection = counter
                                        
                                    }
                            }
                        }.padding(.leading)
                    }
                    Divider()
                    
                    if (categorySelection == 0) {
                    
                        CategoryTitle(name: "Summer", buttonName: "All").padding(.top, 16).onTapGesture(count: 1, perform: {
                            print(userData.child.serverPacks.self)
                            print(userData.child.getSize())
                        })
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(0..<summerFilters.count) { counter in
                                NavigationLink(destination: FilterView(filterItem: summerFilters[counter], related: userData.child.localFilters.filter{ $0.tags!.contains(summerFilters[counter].tags ?? "nonTag") &&  $0.name != summerFilters[counter].name }).environmentObject(userData)) {
                                    FilterPreviewCard(filterItem: summerFilters[counter])
                                }
                                
                            }
                        }.padding().navigationBarTitle("Filters", displayMode: .large)
                        
                    }.frame(height: 270)

                    CategoryTitle(name: "Way to colorize", buttonName: "All").padding(.top,8)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(0..<colorfulFilters.count) { counter in
                                NavigationLink(destination: FilterView(filterItem: colorfulFilters[counter], related: userData.child.localFilters.filter{ $0.tags!.contains(colorfulFilters[counter].tags ?? "nonTag") &&  $0.name != colorfulFilters[counter].name }).environmentObject(userData)) {
                                    FilterPreviewCard(filterItem: colorfulFilters[counter])
                                }   
                            }
                        }.padding()
                        
                    }.frame(height: 270)
                    
                    
                    CategoryTitle(name: "Atmosphere", buttonName: "All").padding(.top,8)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(0..<apmosphereFilters.count) { counter in
                                NavigationLink(destination: FilterView(filterItem: apmosphereFilters[counter], related: userData.child.localFilters.filter{ $0.tags!.contains(apmosphereFilters[counter].tags ?? "nonTag")  &&  $0.name != apmosphereFilters[counter].name }).environmentObject(userData)) {
                                    FilterPreviewCard(filterItem: apmosphereFilters[counter])
                                }
                            }
                        }.padding()
                        
                    }.frame(height: 270)
                        
                        if (userData.child.getSize() != 0) {
                            ForEach(userData.child.serverPacks, id: \.self) { serverpack in
                                
                                
                                PackPreview(packItem: serverpack, filters: userData.child.serverFilters.filter{ $0.isInPack == userData.child.serverPacks[0].id  }).frame( height: 400).padding(.top)
                            }
                        }
                    }
                    else {
                        CategoryTitle(name: circleCategories[categorySelection], buttonName: "").padding(.top, 16)
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 16) {
                                ForEach(0..<circleCategoriesFilters.count, id: \.self) { counter in
                                    NavigationLink(destination: FilterView(filterItem: circleCategoriesFilters[counter])) {
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

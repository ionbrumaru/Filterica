//
//  FiltersList.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 30.07.2020.
//

import SwiftUI
import RealmSwift
struct FiltersList: View {
    @EnvironmentObject private var userData: UserData
    
    @State private var filters: Results<filter>! = try? Realm(configuration: Realm.Configuration(schemaVersion: 1)).objects(filter.self)
    
    @State private var selectedFilter: filter?
    
    private var summerFilters: [filter] = UserData().locFilters.filter{ $0.tags!.contains("Summer") }
    
    private var colorfulFilters: [filter] = UserData().locFilters.filter{ $0.tags!.contains("Color") }
    
    private var apmosphereFilters: [filter] = UserData().locFilters.filter{ $0.tags!.contains("Atmosphere") }
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading) {
                ScrollView(.vertical) {
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            ForEach(0..<5) { counter in
                                FiltersCategory(categoryName: "Urban", categoryImage: Image(uiImage: UIImage(named: "test")!))
                            }
                        }
                    }
                    
                    CategoryTitle(name: "Summer", buttonName: "All").padding(.top, 16)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(0..<summerFilters.count) { counter in
                                NavigationLink(destination: FilterView(filterItem: summerFilters[counter])) {
                                    FilterPreviewCard(filterItem: summerFilters[counter])
                                }
                                
                            }
                        }.padding().navigationBarTitle("Filters", displayMode: .large)
                        
                    }.frame(height: 270)

                    CategoryTitle(name: "Way to colorize", buttonName: "All").padding(.top,8)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(0..<colorfulFilters.count) { counter in
                                NavigationLink(destination: FilterView(filterItem: colorfulFilters[counter])) {
                                    FilterPreviewCard(filterItem: colorfulFilters[counter])
                                }   
                            }
                        }.padding()
                        
                    }.frame(height: 270)
                    
                    
                    CategoryTitle(name: "Atmosphere", buttonName: "All").padding(.top,8)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(0..<apmosphereFilters.count) { counter in
                                NavigationLink(destination: FilterView(filterItem: apmosphereFilters[counter])) {
                                    FilterPreviewCard(filterItem: apmosphereFilters[counter])
                                }
                            }
                        }.padding()
                        
                    }.frame(height: 270)
    
                }
            }
        }
    }
}

struct FiltersList_Previews: PreviewProvider {
    static var previews: some View {
        FiltersList()
    }
}

struct CategoryTitle: View {
    var name: String
    var buttonName: String
    var body: some View {
        HStack{
            Text(name)
                .font(.title2)
                .bold()
                .padding(.leading)
            
            Spacer()
            
            Text(buttonName).font(.body).foregroundColor(Color.primary)
                .padding(.trailing)
        }
    }
}

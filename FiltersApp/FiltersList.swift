//
//  FiltersList.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 30.07.2020.
//

import SwiftUI
import RealmSwift
struct FiltersList: View {
    @State private var filters: Results<filter>! = try! Realm(configuration: Realm.Configuration(schemaVersion: 1)).objects(filter.self)
    
    @State private var selectedFilter: filter?
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading) {
                ScrollView(.vertical) {
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(0..<5) { counter in
                            Circle().frame(width:64, height: 64).padding(.leading,16)
                        }
                        
                    }
                    
                }
                
                    //Divider().padding(.top, 2)
                
                
                HStack{
                    Text("Summer").font(.largeTitle).padding(.leading)
                    
                    Spacer()
                    
                    Button(action: {
                        // your action here
                    }) {
                        Text("All").font(.footnote).foregroundColor(Color.primary)
                    }.padding(.trailing)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(0..<filters.count) { counter in
                                NavigationLink(destination: FilterView(filterItem: filters[counter])) {
                                    FilterPreviewCard(filterItem: filters[counter])
                                                }
                                
                            }
                        }.padding().navigationBarTitle("Filters", displayMode: .large)
                        
                    }.frame(height: 270)
                    Divider()
                    Spacer()
                
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

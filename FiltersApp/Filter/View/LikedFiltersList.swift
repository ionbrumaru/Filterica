//
//  LikedFiltersList.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 14.11.2020.
//

import SwiftUI
import RealmSwift

struct LikedFiltersList: View {
    
    let navtext: LocalizedStringKey =  "Favourite filters"
    
    @State private var filters: [filter] = Array(try! Realm(configuration: Realm.Configuration(schemaVersion: 1)).objects(filter.self))
    

    @State private var likedFilters: [filter] = []

    var body: some View {
        NavigationView {
            VStack {
                //CategoryTitle(name: "Liked Filters", buttonName: "").padding(.top, 16)
                
                if likedFilters.count == 0 {
                    Text("No liked filters by you").opacity(0.6)
                }
                else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(likedFilters, id:\.self) { item in
                            NavigationLink(destination: FilterView(filterItem: item, filters: $filters))
                            {
                                FilterPreviewCard(filterItem: item).fixedSize().frame(height: 340)
                            }
                        }
                    }.padding(.leading).padding(.trailing).navigationBarTitle(navtext, displayMode: .large)
                }
                }
            }.onAppear() {
                likedFilters = filters.filter{ $0.liked == true }
        }
        }
    }
}

struct LikedFiltersList_Previews: PreviewProvider {
    static var previews: some View {
        LikedFiltersList()
    }
}

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
    
    @EnvironmentObject var fs: FilterStorage
    
    @State private var likedFilters: [filter] = []
    
    var body: some View {
        NavigationView {
            VStack {
                if likedFilters.count == 0 {
                    Text("0 liked filters").opacity(0.6)
                }
                else {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(likedFilters, id:\.self) { item in
                                NavigationLink(destination: FilterView(filterItem: item))
                                {
                                    FilterPreviewCard(filterItem: item)
                                        .fixedSize().frame(height: 340)
                                }
                            }
                        }.padding(.leading).padding(.trailing)
                    }
                }
            }.onAppear() {
                likedFilters = fs.filters.filter{ $0.liked == true }
            }
            .navigationBarTitle("Favourite filters", displayMode: .large)
        }
    }
}

struct LikedFiltersList_Previews: PreviewProvider {
    static var previews: some View {
        LikedFiltersList()
    }
}


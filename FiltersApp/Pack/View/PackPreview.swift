//
//  PackPreview.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 02.08.2020.
//

import SwiftUI
// If you are using CocoaPods, in which the SwiftUI support is defined in the same module.
import URLImage

struct PackPreview: View {
    var packItem: pack?
    var filters: [filter]?
    @Binding var filters_all: [filter]
    @State private var isOriginalShowing = false
        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
            ForEach(0..<filters!.count) { counter in
                
                NavigationLink(destination: PackView(filters_all: $filters_all, packItem: packItem, filters: filters_all.filter{ $0.isInPack == packItem!.id }, currentImage: counter)) {
                    
                
                    VStack(alignment: .leading) {
                        HStack{
                        if (filters![counter].imageAfter.contains("LOCAL_")) {
                        Image(uiImage: UIImage(named: filters![counter].imageAfter.replacingOccurrences(of: "LOCAL_", with: ""))!
                        )
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 330, height: 300) // height 240
                        .cornerRadius(12)
                        }
                        else {
                            URLImage(URL(string: filters![counter].imageAfter)!, delay: 0.25,placeholder: Image(systemName: "circle")) { proxy in
                                        proxy.image
                                            .renderingMode(.original)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 330, height: 300) // height 240
                                            .cornerRadius(12)
                            }
                        }
                        }.frame(width: 330, height: 300) // height 240
                        
                        HStack{
                            Text(filters![counter].name.capitalizingFirstLetter()).bold().padding(.leading, 4).foregroundColor(Color.primary)
                            Spacer()
                            //Text("#" + (filters![counter].tags ?? "Filter")).font(.footnote).foregroundColor(Color.primary).opacity(0.8)
                        }
                    }
            }
        }
        }.padding(.leading)
            .padding(.trailing)
            }
    }
}


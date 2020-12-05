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
    var packItem: pack!
    var filters: [filter]?
    @Binding var filters_all: [filter]
    @State private var isOriginalShowing = false
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(0..<filters!.count) { counter in
                    
                    NavigationLink(destination: PackView(packItem: packItem, filters: filters_all.filter{ Int($0.isInPack) == packItem!.id }, filters_all: $filters_all, currentImage: counter)) {
                        
                        VStack(alignment: .leading) {
                            
                            HStack{
                                if (filters![counter].imageAfter.contains("LOCAL_")) {
                                    Image(uiImage: UIImage(named: filters![counter].imageAfter.replacingOccurrences(of: "LOCAL_", with: ""))!
                                    )
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 330, height: 300)
                                    .cornerRadius(12)
                                }
                                else {
                                    URLImage(URL(string: filters![counter].imageAfter)!, delay: 0.25,placeholder: {
                                        ProgressView($0) { progress in
                                            ZStack {
                                                if progress >= 0.0 {
                                                    // The download has started. CircleProgressView displays the progress.
                                                    CircleProgressView(progress).stroke(lineWidth: 8.0)
                                                }
                                            }
                                        }
                                        .frame(width: 50.0, height: 50.0)
                                    }) { proxy in
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
                            }
                        }
                    }
                }
            }.padding(.leading)
            .padding(.trailing)
        }
    }
}


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
    @EnvironmentObject var fs: FilterStorage
    @State private var isOriginalShowing = false
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(0..<filters!.count) { counter in
                    
                    NavigationLink(destination: PackView(packItem: packItem, filters: fs.filters.filter{ Int($0.isInPack) == packItem!.id }, currentImage: counter)) {
                        
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
                                    
                                    URLImage(url: URL(string: filters![counter].imageAfter)!,
                                                     options: URLImageOptions(
                                                        cachePolicy: .returnCacheElseLoad(cacheDelay: nil, downloadDelay: 0.25) // Return cached image or download after delay
                                                     ),
                                                     empty: {
                                                        Text("nothing")            // This view is displayed before download starts
                                                     },
                                                     inProgress: { progress in
                                                        VStack(alignment: .center) {
                                                        if #available(iOS 14.0, *) {
                                                            
                                                                ProgressView()
                                                            
                                                        } else {
                                                            // Fallback on earlier versions
                                                            
                                                                ActivityIndicator(isAnimating: .constant(true), style: .large)
                                                            
                                                        }
                                                        }.frame(width: 330, height: 300)
                                                                        
                                                                      },
                                                     failure: { error, retry in         // Display error and retry button
                                                        VStack {
                                                            Text(error.localizedDescription)
                                                            Button("Retry", action: retry)
                                                        }
                                                     },
                                                     content: { image in                // Content view
                                                        image
                                                            .renderingMode(.original)
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(width: 330, height: 300) // height 240
                                                            .cornerRadius(12)
                                                     })

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


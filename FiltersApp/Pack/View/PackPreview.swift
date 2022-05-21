//
//  PackPreview.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 02.08.2020.
//

import SwiftUI
import URLImage

struct PackPreview: View {
    @EnvironmentObject var fs: FilterStorage
    @State private var isOriginalShowing = false

    var packItem: Pack!
    var filters: [filter]?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(0 ..< filters!.count) { counter in
                    
                    NavigationLink(destination:
                                    PackView(
                                        currentImage: counter,
                                        packItem: packItem,
                                        filters: fs.filters.filter{ Int($0.isInPack) == packItem!.id }
                                    )
                    ) {
                        
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
                                                cachePolicy: .returnCacheElseLoad(cacheDelay: nil, downloadDelay: 0.25)
                                             ),
                                             empty: {
                                        Text("nothing")
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
                                             failure: { error, retry in
                                        VStack {
                                            Text(error.localizedDescription)
                                            Button("Retry", action: retry)
                                        }
                                    },
                                             content: { image in
                                        image
                                            .renderingMode(.original)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 330, height: 300)
                                            .cornerRadius(12)
                                    })

                                }
                            }.frame(width: 330, height: 300)
                            
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


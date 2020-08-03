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
    var filters: [serverFilter]?
    @State private var currentImage = 0
        var body: some View {
            GeometryReader { geometry in
                VStack {
                    
                    CategoryTitle(name: packItem!.name, buttonName: "\(filters!.count) presets").padding(.top,8)
                    
                        ZStack(alignment: .leading) {
                            HStack{
                                
                                URLImage(URL(string: filters![currentImage].imageAfter)!, delay: 0.25,placeholder: Image(systemName: "circle")) { proxy in
                                        proxy.image
                                            .renderingMode(.original)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: geometry.size.width, height: 300)
                                            .clipped()
                                        }
                                
                            }
                            
                            HStack {
                                Button(action: {
                                    // your action here
                                    if (currentImage != 0) { currentImage -= 1}
                                }) {
                                    Image(systemName: "arrow.left")
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                        .foregroundColor(Color.white)
                                }.frame(width: 32, height: 32)
                                
                                Spacer()
                                
                                Button(action: {
                                    // your action here
                                    if (currentImage != filters!.count - 1) { currentImage += 1}
                                }) {
                                    Image(systemName: "arrow.right")
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                        .foregroundColor(Color.white)
                                }.frame(width: 32, height: 32)
                            }.frame(width: geometry.size.width)
                            
                            
                        }
                    
                }
            }
            
        }
    }


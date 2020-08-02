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
                    HStack() {
                        Text(packItem!.name).font(.title)
                        Spacer()
                        Text("6 presets pack")
                    }
                    
                        ZStack(alignment: .leading) {
                            HStack{
                                
                                URLImage(URL(string: filters![currentImage].imageBefore)!, delay: 0.25,placeholder: Image(systemName: "circle")) { proxy in
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
                                        .frame(width: 32, height: 32)
                                        .background(Color.secondary .opacity(0.5)).cornerRadius(50)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    // your action here
                                    if (currentImage != filters!.count - 1) { currentImage += 1}
                                }) {
                                    Image(systemName: "arrow.right")
                                        .resizable()
                                        .frame(width: 32, height: 32)
                                        .background(Color.secondary .opacity(0.5)).cornerRadius(50)
                                }
                            }.frame(width: geometry.size.width)
                            
                            
                        }
                    
                }
            }
            
        }
    }


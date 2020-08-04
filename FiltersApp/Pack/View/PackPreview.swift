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
    @State private var currentImage = 0
    @State private var isOriginalShowing = false
        var body: some View {
            GeometryReader { geometry in
                VStack {
                    
                        ZStack(alignment: .leading) {
                            HStack{
                                if (filters![currentImage].imageBefore.contains("LOCAL_")) {
                                    Image(uiImage:
                                            UIImage(named:  filters![currentImage].imageAfter.replacingOccurrences(of: "LOCAL_", with: ""))!)
                                            .renderingMode(.original)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: geometry.size.width, height: 300)
                                            .clipped()
                                }
                                else {
                                    URLImage(URL(string: filters![currentImage].imageAfter)!, delay: 0.25,placeholder: Image(systemName: "circle")) { proxy in
                                        proxy.image
                                            .renderingMode(.original)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: geometry.size.width, height: 300)
                                            .clipped()
                                        }
                                }
                                
                            }.frame(width: geometry.size.width, height: 300)
                            
                            HStack {
                                
                                HStack {
                                Image(systemName: "arrow.left")
                                    .resizable()
                                    .font(.largeTitle)
                                    .frame(width: 22, height: 22)
                                    .foregroundColor(.white)
                                }
                                
                                .frame(width: 64, height: 300)
                                .contentShape(Rectangle())
                                .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                                    if (currentImage != 0) { currentImage -= 1}
                                }) 
                                Spacer()
                                
                                
                                HStack {
                                Image(systemName: "arrow.right")
                                    .resizable()
                                    .font(.largeTitle)
                                    .frame(width: 22, height: 22)
                                    .foregroundColor(.white)
                                }
                                
                                .frame(width: 64, height: 300)
                                .contentShape(Rectangle())
                                .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                                    if (currentImage != filters!.count - 1) { currentImage += 1}
                                })
                                
                            }.frame(width: geometry.size.width)
                            
                            
                        }
                    
                }
            }
            
        }
    }


//
//  PackNavigationItemsView.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 02.02.2021.
//

import SwiftUI

struct PackNavigationItems: View {
    @Binding var isLiked: Bool
    @Binding var currentImage: Int
    var filters: [filter]?
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "arrow.left")
                    .resizable()
                    .font(.largeTitle)
                    .frame(width: 22, height: 22)
                    .foregroundColor(.white)
            }
            .frame(width: 64, height: 400)
            .contentShape(Rectangle())
            .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                if (currentImage != 0) { currentImage -= 1}
                isLiked = filters![currentImage].liked
            })
            
            Spacer()
            
            HStack {
                Image(systemName: "arrow.right")
                    .resizable()
                    .font(.largeTitle)
                    .frame(width: 22, height: 22)
                    .foregroundColor(.white)
            }
            .frame(width: 64, height: 400)
            .contentShape(Rectangle())
            .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                if (currentImage != filters!.count - 1) { currentImage += 1}
                isLiked = filters![currentImage].liked
            })
        }
    }
}

//
//  LikeButtonView.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 02.02.2021.
//

import SwiftUI
import RealmSwift

struct LikeButton: View {
    @Binding var isLiked: Bool
    @Binding var currentImage: Int

    var didTapLike: ((Bool) -> Void)?
    
    var body: some View {
        Image(systemName: "suit.heart.fill")
            .font(Font.system(size: 30, weight: .regular))
            .foregroundColor(isLiked ? Color(UIColor(named: "MainColor")!) : Color.secondary)
            .onTapGesture {
                self.didTapLike?(!isLiked)
                isLiked.toggle()
            }
    }

}

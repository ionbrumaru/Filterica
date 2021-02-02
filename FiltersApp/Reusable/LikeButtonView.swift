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
    var filters: [filter]?
    
    var body: some View {
        Image(systemName: "suit.heart.fill")
            .font(Font.system(size: 30, weight: .regular))
            .foregroundColor(isLiked ? Color(UIColor(named: "MainColor")!) : Color.secondary)
            //.padding(.trailing,4)
            .onTapGesture {
                do {
                    var realm = try Realm()
                    
                    if (!isLiked) {
                        print("LIKE")
                        
                        let realmFilters = realm.objects(filter.self).filter("name = %@", filters![currentImage].name)
                        
                        if let fltr = realmFilters.first {
                            try! realm.write {
                                fltr.liked = true
                            }
                        }
                        isLiked = true
                        
                    }
                    else {
                        print("dislike")
                        
                        let realmFilters = realm.objects(filter.self).filter("name = %@", filters![currentImage].name)
                        
                        if let fltr = realmFilters.first {
                            try! realm.write {
                                fltr.liked = false
                            }
                        }
                        isLiked = false
                        
                    }
                }
                catch let error as NSError {
                    print(error.localizedDescription)
                }
                
            }.onAppear() {
                isLiked = filters![currentImage].liked
            }
    }
}

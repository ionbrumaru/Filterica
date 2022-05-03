//
//  LoadMoreButtonView.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 02.02.2021.
//

import SwiftUI

struct LoadMoreButton: View {
    @Binding var showLoadMoreButton: Bool
    @Binding var expandableShowHowMany: Int
    let loadmetext: LocalizedStringKey =  "Load more"
    var expandableLoad: [String]
    var body: some View {
        HStack{
            if showLoadMoreButton {
                Button(action: {
                    //
                    if (expandableShowHowMany + 3 < expandableLoad.count) {
                        expandableShowHowMany += 3
                    }
                    else if (expandableShowHowMany + 2 < expandableLoad.count) {
                        expandableShowHowMany += 2
                    }
                    else if (expandableShowHowMany + 1 < expandableLoad.count) {
                        expandableShowHowMany += 1
                    }
                    else {
                        showLoadMoreButton = false
                    }
                    
                    if (showLoadMoreButton) {
                        if (expandableShowHowMany + 1 == expandableLoad.count) {
                            showLoadMoreButton = false
                        }
                    }
                }) {
                    Text(loadmetext)
                        .customButton()
                }.padding()
                
            }
        }
    }
}

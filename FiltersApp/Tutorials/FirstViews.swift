//
//  FirstViews.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 03.08.2020.
//

import SwiftUI

struct FirstViews: View {
    
    @State private var showMain = false
    
    var body: some View {
        
        if (!showMain) {
            GeometryReader { geometry in
                ScrollView  {
                VStack(alignment: .center) {
                    
                    
                    
                    TitleView()
                    
                    VStack(alignment: .leading) {
                        TutorialDetailView(title: "Explore", subTitle: "Explore more than 100 filters in a catalog.", imageName: "rectangle.stack")
                        
                        TutorialDetailView(title: "Compare", subTitle: "Compare between original photo and photo with filter on to see the difference.", imageName: "photo.on.rectangle")
                        
                        TutorialDetailView(title: "Download", subTitle: "Choose any filter you like and download 100% free.", imageName: "arrow.down.to.line")
                        
                        
                        TutorialDetailView(title: "Export", subTitle: "Export filters right to lightroom mobile on your device", imageName: "square.and.arrow.up")
                    }
                    
                    
                    
                    
                    
                }
                .padding(.horizontal)
                
                Spacer(minLength: 30)
                
                Button(action: {
                    showMain = true
                }) {
                    Text("Continue")
                        .customButton()
                }
                .padding(.horizontal)
                }.frame(height: geometry.size.height)
            }
    }
        else { ContentView()}
    }
}


struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.headline)
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            .background(RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(Color(mainColor)))
            .padding(.bottom)
    }
}

extension View {
    func customButton() -> ModifiedContent<Self, ButtonModifier> {
        return modifier(ButtonModifier())
    }
}

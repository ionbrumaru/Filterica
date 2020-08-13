//
//  FirstViews.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 03.08.2020.
//

import SwiftUI

struct FirstViews: View {
    
    @State private var showMain = false
    let title1: LocalizedStringKey = "Explore"
    let desc1: LocalizedStringKey = "Explore more than 100 filters in a catalog."
    
    let title2: LocalizedStringKey = "Compare"
    let desc2: LocalizedStringKey = "Compare between original photo and photo with filter on to see the difference."
    
    let title3: LocalizedStringKey = "Download"
    let desc3: LocalizedStringKey = "Choose any filter you like and download it 100% free."
    
    let title4: LocalizedStringKey = "Export"
    let desc4: LocalizedStringKey = "Export filters right to lightroom mobile on your iPhone"
    
    let continuelabel: LocalizedStringKey = "Continue"
    
    var body: some View {
        
        if (!showMain) {
            GeometryReader { geometry in
                ScrollView  {
                VStack(alignment: .center) {
                    
                    
                    
                    TitleView()
                    
                    VStack(alignment: .leading) {
                        TutorialDetailView(title: title1, subTitle: "Explore more than 100 filters in a catalog.", imageName: "rectangle.stack")
                        
                        TutorialDetailView(title: title2, subTitle: desc2, imageName: "photo.on.rectangle")
                        
                        TutorialDetailView(title: title3, subTitle: desc3, imageName: "arrow.down.to.line")
                        
                        
                        TutorialDetailView(title: title4, subTitle: desc4, imageName: "square.and.arrow.up")
                    }
                    
                    
                    
                    
                    
                }
                .padding(.horizontal)
                
                Spacer(minLength: 30)
                
                Button(action: {
                    showMain = true
                }) {
                    Text(continuelabel)
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

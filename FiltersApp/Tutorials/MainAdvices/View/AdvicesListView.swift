//
//  AdvicesListView.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 27.12.2020.
//

import SwiftUI

struct AdvicesListView: View {
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
            ScrollView() {
                VStack(spacing: 25) {
                    
                    NavigationLink(destination: ScrollView {
                        TutorialView().padding().padding(.top, -10)
                    }) {
                    ZStack() {
                
                    Image(uiImage: UIImage(named: "Barberry_after")!)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: abs(geometry.size.width - 32), height: abs(geometry.size.height / 2.2))
                        .clipped()
                    
                    Text("How to use Filterica")
                        
                        .font(.system(size: 35))
                        .bold()
                        .background(Color.black.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(6)
                        .multilineTextAlignment(.center)
                        
                        
                }.cornerRadius(15)
                    }
                    
                ForEach(localAdvices, id: \.self) { advice in
                    NavigationLink(destination: AdviceView(item: advice)) {
                        ZStack() {
                    
                        Image(uiImage: UIImage(named: advice.imageName)!)
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: abs(geometry.size.width - 32), height: abs(geometry.size.height / 2.2))
                            .clipped()
                        
                        Text(advice.name)
                            
                            .font(.system(size: 35))
                            .bold()
                            .background(Color.black.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(6)
                            .multilineTextAlignment(.center)
                            
                            
                    }.cornerRadius(15)
                    }
                }
                }.padding(.leading,16).padding(.trailing,16)
            }.navigationBarTitle("Tips", displayMode: .large)
        }
        }
    }
}

struct AdvicesListView_Previews: PreviewProvider {
    static var previews: some View {
        AdvicesListView()
    }
}

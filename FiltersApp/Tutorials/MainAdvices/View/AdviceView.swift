//
//  AdviceView.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 31.12.2020.
//

import SwiftUI

struct AdviceView: View {
    var item: advice
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
            VStack(spacing: 0) {
                ZStack(alignment: .top){
                    
                    VStack(alignment: .center) {
                        
                        ZStack {
                            Image(uiImage: UIImage(named: item.imageName)!)
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .ignoresSafeArea( edges: .top)
                                .frame(width: abs(geometry.size.width), height: abs(geometry.size.height / 3.2))
                                .mask(Rectangle().edgesIgnoringSafeArea(.top))
                        }
                    }
                }
                    
                        Text(item.text)
                            .font(.system(size: 14))
                            .padding(.leading)
                            .padding(.trailing)
                            .padding(.top)
                        
                       
                           
                    }
                
                       
            }.navigationBarTitle(item.name, displayMode: .large)
                
                Spacer()
            }
        
    }
}

struct AdviceView_Previews: PreviewProvider {
    static var previews: some View {
        AdviceView(item: localAdvices[0])
    }
}

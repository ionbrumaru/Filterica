//
//  TitleView.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 05.08.2020.
//

import SwiftUI


struct TitleView: View {
    var body: some View {
        VStack(spacing: 0) {
            Image(uiImage: UIImage(named: "mainicon")!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 160, alignment: .center)
                .accessibility(hidden: true)
                .fixedSize()

            Text("Welcome to")
                .bold()
                .font(.system(size: 36))
                .padding(.top, -8)

            Text("Fitrerly app")
                .font(.system(size: 36))
                .bold()
                .foregroundColor(Color(mainColor))
            
            
        }
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}

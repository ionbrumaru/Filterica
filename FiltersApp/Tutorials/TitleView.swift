//
//  TitleView.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 05.08.2020.
//

import SwiftUI


struct TitleView: View {
    var body: some View {
        VStack {
            Image(systemName: "rectangle.fill.on.rectangle.angled.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, alignment: .center)
                .accessibility(hidden: true)

            Text("Welcome to")
                .font(.system(size: 36))

            Text("Fitrerly app")
                .font(.system(size: 36))
                .foregroundColor(Color(mainColor))
        }
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}

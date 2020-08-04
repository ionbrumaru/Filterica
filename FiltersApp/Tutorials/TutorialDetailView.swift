//
//  TutorialDetailView.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 05.08.2020.
//

import SwiftUI

struct TutorialDetailView: View {
    
    var title: String = "title"
        var subTitle: String = "subTitle"
        var imageName: String = "car"
    var body: some View {
        HStack(alignment: .center) {
                    Image(systemName: imageName)
                        .font(.largeTitle)
                        .frame(width: 32)
                        .foregroundColor(Color(mainColor))
                        .padding()
                        .accessibility(hidden: true)

                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.primary)
                            .accessibility(addTraits: .isHeader)

                        Text(subTitle)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(.top)
    }
}

struct TutorialDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialDetailView()
    }
}

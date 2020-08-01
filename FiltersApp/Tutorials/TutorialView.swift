//
//  TutorialView.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 01.08.2020.
//

import SwiftUI

struct TutorialView: View {
    var body: some View {
        VStack(alignment: .leading){
            Text("How To").font(.title).bold().padding(.leading)
            
            HStack(alignment: .top) {
                Text("1.").bold()
                Text("After installing app, download and install Adobe Lightroom app from App Store.")
            }.padding(.top,8)
            
            HStack(alignment: .top) {
                Text("2.").bold()
                Text("Tap 'get preset' button. Then find 'copy to Lightroom' button, and tap it.")
            }.padding(.top,8)
            
            Image(uiImage: UIImage(named: "tutorial1")!).renderingMode(.original)
                .resizable()
                .cornerRadius(20)
                .aspectRatio(contentMode: .fill)
                .padding(20)
            
        }
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}

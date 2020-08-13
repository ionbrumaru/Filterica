//
//  TutorialView.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 01.08.2020.
//

import SwiftUI

struct TutorialView: View {
    
    let desc1: LocalizedStringKey = "How To"
    let desc2: LocalizedStringKey = "After installing app, download and install Adobe Lightroom app from App Store."
    let desc3: LocalizedStringKey = "Tap 'get preset' button. Then find 'copy to Lightroom' button, and tap it."
    let desc4: LocalizedStringKey = "After clicking on the lightroom icon, you will be notified that the preset will apear on next app launch"
    let desc5: LocalizedStringKey = "Open lightroom. Choose new preset image and open it. In the right upper corner tap 'more' icon and choose 'Copy settings'. Then click 'ok'"
    let desc6: LocalizedStringKey = "After you opened your photo, tap an icon in the right upper corner again and choose 'paste settings'"
    
    
    
    var body: some View {
        VStack(alignment: .leading){
            Text(desc1).font(.title).bold().padding(.leading).padding(.bottom, 6)
            
            HStack(alignment: .top) {
                Text("1.").bold().font(.system(size: 16))
                Text(desc2).font(.system(size: 14))
            }.padding(.top,8)
            
            HStack(alignment: .top) {
                Text("2.").bold().font(.system(size: 16))
                Text(desc3).font(.system(size: 14))
            }.padding(.top,8)
            
            Image(uiImage: UIImage(named: "tutorial1")!).renderingMode(.original)
                .resizable()
                .cornerRadius(20)
                .aspectRatio(contentMode: .fill)
                .padding(20)
            
            HStack(alignment: .top) {
                Text("3.").bold().font(.system(size: 16))
                Text(desc4).font(.system(size: 14))
            }.padding(.top,8)
            
            Image(uiImage: UIImage(named: "tutorial2")!).renderingMode(.original)
                .resizable()
                .cornerRadius(20)
                .aspectRatio(contentMode: .fill)
                .padding(20)
            
            HStack(alignment: .top) {
                Text("4.").bold().font(.system(size: 16))
                Text(desc5).font(.system(size: 14))
            }.padding(.top,8)
            
            Image(uiImage: UIImage(named: "tutorial3")!).renderingMode(.original)
                .resizable()
                .cornerRadius(20)
                .aspectRatio(contentMode: .fill)
                .padding(20)
            
            HStack(alignment: .top) {
                Text("4.").bold().font(.system(size: 16))
                Text(desc6).font(.system(size: 14))
            }.padding(.top,8)
            
            Image(uiImage: UIImage(named: "tutorial4")!).renderingMode(.original)
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

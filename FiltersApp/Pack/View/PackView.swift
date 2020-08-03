//
//  PackView.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 02.08.2020.
//

import Foundation
import SwiftUI
import URLImage
struct PackView: View {
     var packItem: pack?
     var filters: [serverFilter]
    var body: some View {
        VStack(alignment: .leading) {
            Text(packItem!.name)
            VStack{
                ForEach(filters ?? [], id: \.self) { filter in
                    URLImage(URL(string: filter.imageBefore)!)
                }
            }
        }
    }
}

struct PackView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}

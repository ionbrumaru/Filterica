//
//  ContentView.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 30.07.2020.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        FiltersList()
            /*
            .onAppear {
            
            let stringPath = Bundle.main.path(forResource: "filter", ofType: "dng")
            
            let a = filter(name: "MountainFX", filterDescription: "adds a fantastic blur to image. So gorgeus that you can use it with any type of image even if its black and white", tags: "nature,mountains,hiking", filterFileURL: "https://kazantsev-ef.ru/ios/Dragon_r_Paren_krd.dng", imageBefore: UIImage(named: "test")?.pngData(), imageAfter: UIImage(named: "test2")?.pngData())
            
            StorageManager.saveObject(a)
           
        }
 */
 
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

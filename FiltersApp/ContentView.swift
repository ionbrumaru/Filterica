//
//  ContentView.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 30.07.2020.
//

import SwiftUI
import RealmSwift
struct ContentView: View {
    
    @State private var packs: [pack] = Array(try! Realm().objects(pack.self))
    @State private var hasTimeElapsed = false
    
    @State private var hasLoaded = false
    private var timeout = 1.5
    
    @State private var recursion = 0
    
    var body: some View {
        
        HStack{
            if hasLoaded {
                FiltersList().accentColor(Color(mainColor))
            }
            else {
                VStack {
                    ZStack {
                        
                        Image(uiImage: UIImage(named: "mainicon")!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 160, alignment: .center)
                            .accessibility(hidden: true)
                            .fixedSize()
                        
                        ActivityIndicator(isAnimating: .constant(true), style: .large)
                    }
                    Text("Loading...").opacity(0.8)
                } /////////////
            }
        }.onAppear(perform: delayCheck)
        
            /*
            .onAppear {
            
            let stringPath = Bundle.main.path(forResource: "filter", ofType: "dng")
            
            let a = filter(name: "MountainFX", filterDescription: "adds a fantastic blur to image. So gorgeus that you can use it with any type of image even if its black and white", tags: "nature,mountains,hiking", filterFileURL: "https://kazantsev-ef.ru/ios/Dragon_r_Paren_krd.dng", imageBefore: UIImage(named: "test")?.pngData(), imageAfter: UIImage(named: "test2")?.pngData())
            
            StorageManager.saveObject(a)
           
        }
 */
 
    }
    
    private func delayCheck() {
            recursion += 1
            // Delay of 7.5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
                let newpacks: [pack] = Array(try! Realm(configuration: Realm.Configuration(schemaVersion: 1)).objects(pack.self))
                if newpacks.count != 0 {
                    hasLoaded = true
                    hasTimeElapsed = true
                    
                }
                else {
                    if recursion <= 3 {
                    delayCheck()
                    }
                    else {
                        //continue without internet
                        hasLoaded = true
                        hasTimeElapsed = true
                        
                    }
                }
                
            }
        }
    
    
}


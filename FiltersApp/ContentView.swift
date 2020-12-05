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
        TabView {
            if hasLoaded {
                FiltersList().accentColor(Color(mainColor)).tabItem {
                    Image(systemName: "rectangle.on.rectangle.angled.fill")
                    Text("Filters")
                }
                
                LikedFiltersList()
                    .tabItem {
                        Image(systemName: "star.fill")
                        Text("Favourite")
                    }
            }
            else {
                VStack {
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                }
            }
        }.accentColor(Color(UIColor(named: "MainColor")!.cgColor))
        .onAppear(perform: delayCheck)
        
    }
    
    //made a delay so that we can wait request to server and answer back
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


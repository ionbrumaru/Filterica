//
//  ContentView.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 30.07.2020.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    
    @EnvironmentObject var fs: FilterStorage
    @State private var hasTimeElapsed = false
    
    @State private var hasLoaded = false
    private var timeout = 1.5
    
    @State private var recursion = 0
    
    var body: some View {
        TabView {
            if hasLoaded {
                FiltersList().environmentObject(fs)
                    .accentColor(Color(mainColor)).tabItem {
                    Image(systemName: "rectangle.on.rectangle.angled.fill")
                    Text("Filters")
                }
                
                AdvicesListView().environmentObject(fs)
                    .tabItem {
                    Image(systemName: "lightbulb.fill")
                    Text("Tips")
                }
                
                LikedFiltersList().environmentObject(fs)
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
        }.accentColor(Color("MainColor"))
        .onAppear(perform: delayCheck)
        
    }
    
    //made a delay so that we can wait request to server and answer back
    private func delayCheck() {
        recursion += 1
        // Delay of 7.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
            fs.packs = Array(try! Realm(configuration: Realm.Configuration(schemaVersion: 1)).objects(pack.self))
            fs.filters = Array(try! Realm(configuration: Realm.Configuration(schemaVersion: 1)).objects(filter.self))
            if fs.packs.count >= 3 {
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


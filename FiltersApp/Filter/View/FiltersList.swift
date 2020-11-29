//
//  FiltersList.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 30.07.2020.
//

import SwiftUI
import RealmSwift
struct FiltersList: View {
    
    @State private var noInternet: Bool = false
    
    @State private var filters: [filter] = Array(try! Realm(configuration: Realm.Configuration(schemaVersion: 1)).objects(filter.self))
    
    @State private var packs: [pack] = Array(try! Realm(configuration: Realm.Configuration(schemaVersion: 1)).objects(pack.self))
    
    @State private var selectedFilter: filter?
    
    private var circleCategories: [String] = ["All", "travel", "color", "nature", "urban", "summer", "atmosphere"]
    
    @State private var circleCategoriesFilters: [filter] = []
    
    @State private var categorySelection = 0
    
    private var expandableLoad: [String] = ["Stay_home_PACK","Influencers_PACK","France_PACK","Moody_PACK","urban_filters", "asia_filters", "lights_filters", "neon_filters","nature_filters", "DONTDELETE"]
    @State private var expandableShowHowMany = 0
    @State private var showLoadMoreButton = true
    
    
    let Navtext: LocalizedStringKey =  "Filters"
    var body: some View {
        NavigationView{
            VStack(alignment: .leading) {
                
                ScrollView(.vertical, showsIndicators: false) {

                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {
                            ForEach(0..<6) { counter in
                                FiltersCategory(categoryName: circleCategories[counter], categoryImage: Image(uiImage: UIImage(named: "\(circleCategories[counter])_small")!))
                                    .onTapGesture {
                                        
                                        if (counter != 0)
                                        {
                                            circleCategoriesFilters = filters.filter{ $0.tags!.contains(circleCategories[counter]) }
                                        }
                                        categorySelection = counter
                                    }
                            }
                        }.padding(.leading)
                    }
                    Divider()
                    
                    if (categorySelection == 0) {
                        
                        if (!noInternet) {
                        ShowStaticPacks(packname: "Autumn", filters: $filters, packs: $packs)
                        }
                        
                        ShowStaticFilters(filters: $filters, tag: "atmosphere", label: "Atmosphere")
                        
                        ShowStaticPacks(packname: "Portraits", filters: $filters, packs: $packs)
                        
                        ShowStaticFilters(filters: $filters, tag: "color", label: "Way to colorize")
                        
                        ShowStaticPacks(packname: "Sun kissed", filters: $filters, packs: $packs)
                        
                        ShowStaticFilters(filters: $filters, tag: "summer", label: "Summertime").onAppear(){
                            if(packs.filter{$0.name == "Portraits"}.count == 0) {
                                noInternet = true
                                
                            }
                            else {noInternet = false }
                        }.padding(.top,-15)
                        
                        ShowStaticPacks(packname: "Night life", filters: $filters, packs: $packs)
                        
                        
                        
                        if (!noInternet) {
                        ForEach(0 ..< expandableShowHowMany, id: \.self) { counter1 in
                            
                            if (expandableLoad[counter1].contains("_filters")) {
                                
                                let currentTag = expandableLoad[counter1].replacingOccurrences(of: "_filters", with: "")
                                
                                if filters.filter{ $0.tags!.contains(currentTag) }.count >= 2 {
                                    ShowStaticFilters(filters: $filters, tag: currentTag, label: currentTag)
                                }
                                
                            }
                            else if (expandableLoad[counter1].contains("_PACK")) {
                                let pckname = (expandableLoad[counter1].replacingOccurrences(of: "_PACK", with: "")).replacingOccurrences(of: "_", with: " ")
                                let packfiltered = packs.filter{ $0.name.contains(pckname) }
                                
                                if packfiltered.count != 0 {
                                    
                                    let pack = packfiltered[0]
                                    CategoryTitle(name: pckname, buttonName: "\(filters.filter{ Int($0.isInPack) == pack.id  }.count) presets").padding(.top,8)
                                    
                                    PackPreview(packItem: pack, filters: filters.filter{ Int($0.isInPack) == pack.id  }, filters_all: $filters).frame( height: 330)
                                }
                            }
                        }
                        
                        LoadMoreButton(showLoadMoreButton: $showLoadMoreButton, expandableShowHowMany: $expandableShowHowMany, expandableLoad: expandableLoad)
                        }
                    }
                    else {
                        
                        OneColumnFiltersView(circleCategories: circleCategories, categorySelection: $categorySelection, circleCategoriesFilters: $circleCategoriesFilters, filters: $filters)
                    }
                    
                }//.navigationBarHidden(true)
                .alert(isPresented: $noInternet ){
                    Alert(title: Text("No internet connection"), message: Text("Make sure your device is connected to the internet."), dismissButton: .default(Text("Continue offline")))
                }
            }
        }
    }
}

struct CategoryTitle: View {
    var name: String
    var buttonName: String
    var body: some View {
        HStack{
            Text(name.capitalizingFirstLetter())
                .font(.title)
                .bold()
                .padding(.leading)
            
            Spacer()
            
            Text(buttonName).font(.body).foregroundColor(Color(mainColor))
                .padding(.trailing)
        }
    }
}

struct LoadMoreButton: View {
    @Binding var showLoadMoreButton: Bool
    @Binding var expandableShowHowMany: Int
    let loadmetext: LocalizedStringKey =  "Load more"
    var expandableLoad: [String]
    var body: some View {
        HStack{
            if showLoadMoreButton {
                Button(action: {
                    //
                    if (expandableShowHowMany + 3 < expandableLoad.count) {
                        expandableShowHowMany += 3
                    }
                    else if (expandableShowHowMany + 2 < expandableLoad.count) {
                        expandableShowHowMany += 2
                    }
                    else if (expandableShowHowMany + 1 < expandableLoad.count) {
                        expandableShowHowMany += 1
                    }
                    else {
                        showLoadMoreButton = false
                    }
                    
                    if (showLoadMoreButton) {
                        if (expandableShowHowMany + 1 == expandableLoad.count) {
                            showLoadMoreButton = false
                        }
                    }
                }) {
                    Text(loadmetext)
                        .customButton()
                }.padding()
                
            }
        }
    }
}

struct ShowStaticFilters: View {
    @Binding var filters: [filter]
    var tag: String
    var label: String
    var body: some View {
        VStack {
            CategoryTitle(name: label, buttonName: "").padding(.top, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<filters.filter{ $0.tags!.contains(tag) }.count) { counter in
                        
                        NavigationLink(destination: FilterView(filterItem: filters.filter{ $0.tags!.contains(tag) }[counter], filters: $filters))
                        {
                            FilterPreviewCard(filterItem: filters.filter{ $0.tags!.contains(tag) }[counter])
                        }
                        
                    }
                }.padding().navigationBarTitle("Filters", displayMode: .large)
                
            }.frame(height: 340)
        }
    }
}

struct OneColumnFiltersView: View {
    var circleCategories: [String]
    @Binding var categorySelection: Int
    @Binding var circleCategoriesFilters: [filter]
    @Binding var filters: [filter]
    var body: some View {
        VStack {
            CategoryTitle(name: circleCategories[categorySelection], buttonName: "").padding(.top, 16)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(0..<circleCategoriesFilters.count, id: \.self) { counter in
                        NavigationLink(destination: FilterView(filterItem: circleCategoriesFilters[counter], filters: $filters))
                        {
                            FilterPreviewCard(filterItem: circleCategoriesFilters[counter]).fixedSize().frame(height: 340)
                        }
                    }
                }.padding(.leading).padding(.trailing).navigationBarTitle(circleCategories[categorySelection], displayMode: .large)
            }
        }
    }
}

struct ShowStaticPacks: View {
    var packname: String
    @Binding var filters: [filter]
    @Binding var packs: [pack]
    var body: some View {
        VStack {
            
            let pack = packs.filter{$0.name == packname}
            
            if(pack.count == 1){
                
                
                CategoryTitle(name: pack[0].name, buttonName: "\(filters.filter{ Int($0.isInPack) == pack[0].id  }.count) presets").padding(.top,8)
                
                PackPreview(packItem: pack[0], filters: filters.filter{ Int($0.isInPack) == pack[0].id  }, filters_all: $filters).frame( height: 330)
                
            }
            
        }
    }
}

func HasAnyTag(filter1: filter, filter2:filter) -> Bool {
    var bl = false
    for tag1 in filter1.tags!.split(separator: ","){
        
        for tag2 in filter2.tags!.split(separator: ","){
            if tag1 == tag2 && filter1.name != filter2.name  {
                bl = true
                break
            }
        }
        
        if bl == true {break}
    }
    
    return bl
}

//
//  FiltersList.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 30.07.2020.
//

import SwiftUI
import RealmSwift
struct FiltersList: View {
    
    @EnvironmentObject var fs: FilterStorage

    @State private var selectedFilter: filter?
    
    @State private var circleCategoriesFilters: [filter] = []
    
    @State private var categorySelection = 0
    
    @State private var expandableShowHowMany = 3
    
    @State private var showLoadMoreButton = true
    @State private var showActionSheet = false
    @State private var showCameraSheet = false
    
    @State private var noInternet: Bool = false

    var body: some View {
        NavigationView{
            VStack(alignment: .leading) {
                ScrollView(.vertical, showsIndicators: false) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {
                            ForEach(0..<5) { counter in
                                NavigationLink(destination: OneColumnFiltersView(categorySelection: $categorySelection, circleCategoriesFilters: $circleCategoriesFilters).onAppear() { // <<-- here
                                    circleCategoriesFilters = fs.filters.filter{ $0.tags!.contains(fs.circleCategories[counter]) }
                                    
                                    categorySelection = counter
                                 })
                                {
                                    FiltersCategory(categoryName: fs.circleCategories[counter], categoryImage: Image(uiImage: UIImage(named: "\(fs.circleCategories[counter])_small")!))
                                        
                                } 
                            }
                        }.padding(.leading)
                    }
                    Divider().onAppear(){
                        if(fs.packs.filter{$0.name == "Portraits"}.count == 0) {
                                noInternet = true

                            }
                            else {noInternet = false }
                        }
                        
                        if (!noInternet) {
                            ForEach(0 ..< expandableShowHowMany, id: \.self) { counter1 in
                                
                                if (fs.expandableLoad[counter1].contains("_filters")) {
                                    
                                    let currentTag = fs.expandableLoad[counter1].replacingOccurrences(of: "_filters", with: "")
                                    
                                    if fs.filters.filter{ $0.tags!.contains(currentTag) }.count >= 2 {
                                        ShowStaticFilters(tag: currentTag, label: currentTag)
                                    }
                                    
                                }
                                else if (fs.expandableLoad[counter1].contains("_PACK")) {
                                    let pckname = (fs.expandableLoad[counter1].replacingOccurrences(of: "_PACK", with: "")).replacingOccurrences(of: "_", with: " ")
                                    let packfiltered = fs.packs.filter{ $0.name.contains(pckname) }
                                    
                                    if packfiltered.count != 0 {
                                        
                                        let pack = packfiltered[0]
                                        CategoryTitle(name: pckname, buttonName: "\(fs.filters.filter{ Int($0.isInPack) == pack.id  }.count) presets").padding(.top,8)
                                        
                                        PackPreview(packItem: pack, filters: fs.filters.filter{ Int($0.isInPack) == pack.id  })
                                            .frame( height: 330)
                                    }
                                }
                            }
                            
                            LoadMoreButton(showLoadMoreButton: $showLoadMoreButton, expandableShowHowMany: $expandableShowHowMany, expandableLoad: fs.expandableLoad)
                        }
                    
                    
                    
                }
                .navigationBarItems(
                    //leading: Button(action:{showCameraSheet = true}) {
                    
//                    if #available(iOS 14.0, *) {
//                    NavigationLink(destination: CameraFilterView())
//                    {
//                        Image(systemName: "camera")
//                    }
//                    }

                //},
                trailing: Button(action:{showActionSheet = true}) {
                    Text("About")
                })
                
                
                .alert(isPresented: $noInternet ){
                    Alert(title: Text("No internet connection"), message: Text("Make sure your device is connected to the internet."), dismissButton: .default(Text("Continue offline")))
                }
            }.actionSheet(isPresented: $showActionSheet) {
                ActionSheet(title: Text("About"), message: Text("Select document to open in browser"), buttons: [
                    .default(Text("Privacy Policy")) {
                        guard let url = URL(string: "https://kazantsev-ef.ru/ios/Privacy_Policy.pdf") else { return }
                        UIApplication.shared.open(url)
                    },
                    .default(Text("Terms and Conditions")) {
                        guard let url = URL(string: "https://kazantsev-ef.ru/ios/Terms_and_Conditions.pdf") else { return }
                        UIApplication.shared.open(url)
                    },
                    .cancel() {showActionSheet = false}
                ])
            }
            .navigationBarTitle("Presets", displayMode: .large)
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

struct ShowStaticFilters: View {
    @EnvironmentObject var fs: FilterStorage
    var tag: String
    var label: String
    var body: some View {
        VStack {
            CategoryTitle(name: label, buttonName: "").padding(.top, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<fs.filters.filter{ $0.tags!.contains(tag) }.count) { counter in
                        
                        NavigationLink(destination: FilterView(filterItem: fs.filters.filter{ $0.tags!.contains(tag) }[counter]))
                        {
                            FilterPreviewCard(filterItem: fs.filters.filter{ $0.tags!.contains(tag) }[counter])
                                .frame(height: 340)
                        }
                        
                    }
                }.padding().navigationBarTitle("Filters")
                
            }.frame(height: 340)
        }
    }
}

struct OneColumnFiltersView: View {
    @Binding var categorySelection: Int
    @Binding var circleCategoriesFilters: [filter]
    @EnvironmentObject var fs: FilterStorage
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(0..<circleCategoriesFilters.count, id: \.self) { counter in
                        NavigationLink(destination: FilterView(filterItem: circleCategoriesFilters[counter]))
                        {
                            FilterPreviewCard(filterItem: circleCategoriesFilters[counter]).fixedSize().frame(height: 340)
                        }
                    }
                }.padding(.leading)
                .padding(.trailing)
                .navigationBarTitle(fs.circleCategories[categorySelection])
            }
        }
    }
}

struct ShowStaticPacks: View {
    var packname: String
    @EnvironmentObject var fs: FilterStorage
    
    var body: some View {
        VStack {
            let pack = fs.packs.filter{$0.name == packname}
            
            if(pack.count == 1){
                CategoryTitle(name: pack[0].name, buttonName: "\(fs.filters.filter{ Int($0.isInPack) == pack[0].id  }.count) presets").padding(.top,8)
                
                PackPreview(packItem: pack[0], filters: fs.filters.filter{ Int($0.isInPack) == pack[0].id  }).frame( height: 330)
                
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

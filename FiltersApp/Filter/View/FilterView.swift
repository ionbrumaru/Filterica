//
//  FilterView.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 30.07.2020.
//

import SwiftUI
import URLImage
import RealmSwift
struct FilterView: View {
    
    var filterItem: filter
    @Binding var filters: [filter]
    var showTutorial: Bool =  false
    
    @State private var isOriginalShowing = false
    @State private var showShareSheet = false
    
    @State private var showImageInfo: Bool = false
    
    @State private var fileurl : String?
    @State private var isLoading : Bool = false
    
    @State private var showTutorialSheet: Bool =  false
    
    @State private var isShareButtonDisabled: Bool = true
    @State private var showRelated: Bool = true

    
    var body: some View {
        
        GeometryReader { geometry in
            
            ScrollView(.vertical, showsIndicators: false ) {
                VStack(alignment: .leading)
                {
                    
                    HStack{
                        
                        if (filterItem.imageBefore.contains("LOCAL_")) {
                            Image(uiImage: isOriginalShowing ?
                                    UIImage(named: filterItem.imageBefore.replacingOccurrences(of: "LOCAL_", with: ""))! : UIImage(named: filterItem.imageAfter.replacingOccurrences(of: "LOCAL_", with: ""))!
                            )
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: 350)
                            .clipped()
                        }
                        else {
                            URLImage(URL(string: isOriginalShowing ? filterItem.imageBefore : filterItem.imageAfter)!, delay: 0.25,placeholder: {
                                ProgressView($0) { progress in
                                    ZStack {
                                        if progress >= 0.0 {
                                            // The download has started. CircleProgressView displays the progress.
                                            CircleProgressView(progress).stroke(lineWidth: 8.0)
                                        }
                                        
                                    }
                                }
                                .frame(width: 50.0, height: 50.0)
                            }) { proxy in
                                proxy.image
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geometry.size.width, height: 350)
                                    .clipped()
                            }
                        }
                    }.navigationBarTitle(filterItem.name, displayMode: .large)
                    .frame(width: geometry.size.width, height: 350)
                    
                    
                    .onTouchDown({
                        isOriginalShowing = true
                        
                    }) {
                        isOriginalShowing = false
                        
                    }
                    
                    HStack(){
                        Spacer()
                        Text("Hold photo to see without filter") .font(.system(size: 12))
                        Spacer()
                    }
                    
                    UnderImageLinedView(filterItem: filterItem, showShareSheet: $showShareSheet, showImageInfo: $showImageInfo, isLoading: $isLoading)
                    
                    if (showRelated) {
                        let relatedFilters = filters.filter{ HasAnyTag(filter1: $0, filter2: filterItem) }
                        if relatedFilters.count > 2 {
                            Text("More like this").font(.title).bold().padding(.leading)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(0..<relatedFilters.count) { counter in
                                        NavigationLink(destination: FilterView(filterItem: relatedFilters[counter], filters: $filters)) {
                                            FilterPreviewCard(filterItem: relatedFilters[counter]).frame(height: 280).cornerRadius(6).clipped()
                                        }
                                    }
                                }.padding()
                                
                            }.frame(height: 250).padding(.bottom, 30)
                        }
                    }
                    
                    if (showTutorial){
                        Divider().padding(.bottom, 4).padding(.leading).padding(.trailing).padding(.top, 4)
                        TutorialView().padding(.leading,8).padding(.trailing, 8)
                    }
                    
                }
//                .onAppear() {
//                    fileurl = getURLtoFile()
//                    DispatchQueue.main.async {
//                        loadFilter(filterfileurl: filterItem.filterFileUrl)
//                    }
//                }
            }
            .navigationBarItems(trailing:
                                    
                                    HStack(spacing: 20) {
                                        Button(action: {
                                            self.showTutorialSheet = true
                                        }) {
                                            Text("Help")
                                        }.sheet(isPresented: $showTutorialSheet) {
                                            ScrollView {
                                                TutorialView().padding()
                                            }
                                        }
                                        
                                        Button(action: {
                                            self.showShareSheet = true
                                            print("presented")
                                            
                                        }) {
                                            Image(systemName: "square.and.arrow.up")
                                            
                                        }.disabled(isShareButtonDisabled)
                                        .sheet(isPresented: $showImageInfo) {
                                            ImageInfoView(filterItem: filterItem)
                                        }
                                    }
            )
        }
        
    }
    
    private func loadFilter(filterfileurl: String) {
        print("LOAD FILTER FUNC")
        let urlString = filterfileurl
        
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                // we got some data back!
                fileurl = (data.dataToFile(fileName: "filter.dng")!.absoluteString)!
                isShareButtonDisabled = false
                isLoading = false
            }
            
            
            // if we're still here it means the request failed somehow
        }.resume()
    }
    
    
    
    
}

private func getURLtoFile() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    
    let filePath = (documentsDirectory as NSString).appendingPathComponent("filter.dng")
    return filePath
}


struct UnderImageLinedView: View {
    var filterItem: filter
    
    @Binding var showShareSheet: Bool
    @Binding var showImageInfo: Bool
    @Binding var isLoading: Bool
    @State private var fileurl : String?
    @State var isLiked = false
    let getfiltertext: LocalizedStringKey =  "  Get filter  "
    
    var body: some View {
        Divider().padding(.bottom, 2).padding(.leading).padding(.trailing)
        
        HStack{
            Text("#" + (filterItem.tags ?? "Filter")).bold()

            Image(systemName: "suit.heart.fill")
                .font(Font.system(size: 30, weight: .regular))
                .foregroundColor(isLiked ? Color(UIColor(named: "MainColor")!) : Color.secondary)
                //.padding(.trailing,4)
                .onTapGesture {
                    do {
                        var realm = try Realm()
                        
                        if (!isLiked) {
                            print("LIKE")
                            
                            let realmFilters = realm.objects(filter.self).filter("name = %@", filterItem.name)
                            
                            if let fltr = realmFilters.first {
                                try! realm.write {
                                    fltr.liked = true
                                }
                            }
                            isLiked = true
                        }
                        else {
                            print("dislike")
                            
                            let realmFilters = realm.objects(filter.self).filter("name = %@", filterItem.name)
                            
                            if let fltr = realmFilters.first {
                                try! realm.write {
                                    fltr.liked = false
                                }
                            }
                            isLiked = false
                        }
                    }
                    catch let error as NSError {
                        print(error.localizedDescription)
                    }
                    
                }.onAppear() {
                    isLiked = filterItem.liked
                }
            
            Spacer()
            
            ActivityIndicator(isAnimating: $isLoading, style: .large) /////////////
            
            Button(action: {
                showImageInfo.toggle()
                
            }) {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(Color.secondary)
            }.padding(.leading,4)
            
            Button(action: {
                //self.showShareSheet.toggle()
                isLoading = true
                DispatchQueue.main.async {
                    fileurl = getURLtoFile()
                    downloadFilter(filterfileurl: filterItem.filterFileUrl)
                }
            }) {
                Text(getfiltertext)
                    .font(.system(size: 20))
                    .padding(2)
                    .foregroundColor(Color.white)
                    .background(Color(mainColor))
                    .cornerRadius(10)
            }
        }.padding(.leading,8).padding(.trailing,8).sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: [NSURL(fileURLWithPath: getURLtoFile())])
        }
        
        Divider().padding(.bottom, 4).padding(.leading).padding(.trailing)
    }
    
    private func downloadFilter(filterfileurl: String) {
        print("started fetching url")
        let urlString = filterfileurl
        
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        
        print("before loading data")
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                fileurl = (data.dataToFile(fileName: "filter.dng")?.absoluteString)!
                showShareSheet.toggle()
                isLoading = false
            }
        }.resume()
    }
    
    private func getURLtoFile() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        
        let filePath = (documentsDirectory as NSString).appendingPathComponent("filter.dng")
        return filePath
    }
}



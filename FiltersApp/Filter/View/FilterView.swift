//
//  FilterView.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 30.07.2020.
//

import SwiftUI
import URLImage
import RealmSwift
import StoreKit

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
                            
                            URLImage(url: URL(string: isOriginalShowing ? filterItem.imageBefore : filterItem.imageAfter)!,
                                     options: URLImageOptions(
                                        cachePolicy: .returnCacheElseLoad(cacheDelay: nil, downloadDelay: 0.25) // Return cached image or download after delay
                                     ),
                                     empty: {
                                        Text("nothing")            // This view is displayed before download starts
                                     },
                                     inProgress: { progress in
                                        VStack(alignment: .center) {
                                            if #available(iOS 14.0, *) {
                                                
                                                ProgressView()
                                                
                                            } else {
                                                // Fallback on earlier versions
                                                ActivityIndicator(isAnimating: .constant(true), style: .large)
                                                
                                            }
                                        }.frame(width: 330, height: 300)
                                        
                                     },
                                     failure: { error, retry in         // Display error and retry button
                                        VStack {
                                            Text(error.localizedDescription)
                                            Button("Retry", action: retry)
                                        }
                                     },
                                     content: { image in                // Content view
                                        image
                                            .renderingMode(.original)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: geometry.size.width, height: 350)
                                            .clipped()
                                     })
                            
                        }
                    }.navigationBarTitle(filterItem.name)
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
                .onAppear() {
                    self.adviceReview()
                }
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
    
    private func adviceReview() {
        // If the count has not yet been stored, this will return 0
        var count = UserDefaults.standard.integer(forKey: "reviewCounter")
        count += 1
        UserDefaults.standard.set(count, forKey: "reviewCounter")
        
        print("Process completed \(count) time(s)")
        
        // Get the current bundle version for the app
        let infoDictionaryKey = kCFBundleVersionKey as String
        guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String
        else { fatalError("Expected to find a bundle version in the info dictionary") }
        
        
        // Has the process been completed several times and the user has not already been prompted for this version?
        if count == 4 {
            let twoSecondsFromNow = DispatchTime.now() + 4.0
            DispatchQueue.main.asyncAfter(deadline: twoSecondsFromNow) {
                
                SKStoreReviewController.requestReview()
                
            }
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



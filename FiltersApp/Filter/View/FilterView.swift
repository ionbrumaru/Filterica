//
//  FilterView.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 30.07.2020.
//

import SwiftUI
import URLImage
struct FilterView: View {
    var filterItem: filter
    @Binding var filters: [filter]
    @State private var isOriginalShowing = false
    @State private var showShareSheet = false
    
    
    @State private var celsius: Double = 0
    
    @State private var showImageInfo: Bool = false
    
    @State private var fileurl : String?
    @State private var isLoading : Bool = true
    var showTutorial: Bool =  false
    
    @State private var showTutorialSheet: Bool =  false
    
    @State private var isShareButtonDisabled: Bool = true
    @State private var showRelated: Bool = false
    var related: [filter]?
    
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
                        /*
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width)
                        */
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: 350)
                        .clipped()
                      
                        
                        
                            
                        }
                        else {
                        URLImage(URL(string: isOriginalShowing ? filterItem.imageBefore : filterItem.imageAfter)!, delay: 0.25,placeholder: Image(systemName: "circle")) { proxy in
                                    proxy.image
                                        /*
                                        .renderingMode(.original)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: geometry.size.width)
 */
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
                    
                    Divider().padding(.bottom, 2).padding(.leading).padding(.trailing)
                    
                    HStack{
                        Text("#" + (filterItem.tags ?? "Filter")).bold()
                        
                        Button(action: {
                            showImageInfo.toggle()
                            
                        }) {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(Color.secondary)
                        }.padding(.leading,4)
                        Spacer()
                        
                        ActivityIndicator(isAnimating: $isLoading, style: .large) /////////////
                        
                        Button(action: {
                            self.showShareSheet.toggle()
                        }) {
                            Text("  Get filter  ")
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
                    
                    if (showRelated) {
                        
                        Text("More like this").font(.title).bold().padding(.leading)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(0..<related!.count) { counter in
                                    NavigationLink(destination: FilterView(filterItem: related![counter], filters: $filters, related: filters.filter{ ($0.tags!.split(separator: ",")).intersects(with: related![counter].tags!.split(separator: "," ) ) &&  $0.name != related![counter].name})) {
                                        FilterPreviewCard(filterItem: related![counter]).frame(height: 280).cornerRadius(6).clipped()
                                    }
                                }
                            }.padding()
                            
                        }.frame(height: 250).padding(.bottom, 30)
                    }
                    
                    if (showTutorial){
                        Divider().padding(.bottom, 4).padding(.leading).padding(.trailing).padding(.top, 4)
                        TutorialView().padding(.leading,8).padding(.trailing, 8)
                    }
                    
                }
                
            }
            .navigationBarItems(trailing:
                                    
                                    HStack(spacing: 20) {
                                        Button(action: {
                                            
                                            
                                            self.showTutorialSheet = true
                                            print("presented")
                                            
                                        }) {
                                            //Image(systemName: "questionmark.circle")
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
        .onAppear() {
            
            if (related?.count ?? 0 > 1)
            {
                showRelated = true
            }
            
            fileurl = getURLtoFile()
            DispatchQueue.main.async {
                fetchNearbyPlaces(filterfileurl: filterItem.filterFileURL)
            }
            
        }
    }
    
    private func fetchNearbyPlaces(filterfileurl: String) {
        let urlString = filterfileurl
        
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                // we got some data back!
                print(data)
                
                
                fileurl = (data.dataToFile(fileName: "filter.dng")?.absoluteString)!
                isShareButtonDisabled = false
                isLoading = false
            }
            
            // if we're still here it means the request failed somehow
        }.resume()
    }
    
    private func getURLtoFile() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        
        let filePath = (documentsDirectory as NSString).appendingPathComponent("filter.dng")
        return filePath
    }
    
    
}


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
    @Binding var filters_all: [filter]
    var packItem: pack?
    var filters: [filter]?
    
    @State var currentImage = 0
    @State private var isOriginalShowing = false
    @State private var showImageInfo: Bool = false
    @State private var showShareSheet = false
    @State private var fileurl : String?
    @State private var isLoading : Bool = false
    @State private var showTutorialSheet : Bool = false
    @State private var showRelated: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .bottomLeading) {
                    
                    ZStack(alignment: .leading) {
                        HStack{
                            if (filters![currentImage].imageBefore.contains("LOCAL_")) {
                                Image(uiImage:
                                        UIImage(named: isOriginalShowing ? filters![currentImage].imageBefore.replacingOccurrences(of: "LOCAL_", with: ""): filters![currentImage].imageAfter.replacingOccurrences(of: "LOCAL_", with: ""))!)
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geometry.size.width, height: 400)
                                    .clipped()
                                    .contentShape(TapShape())
                            }
                            else {
                                URLImage(URL(string: isOriginalShowing ? filters![currentImage].imageBefore: filters![currentImage].imageAfter)!,placeholder: Image(systemName: "circle")) { proxy in
                                    proxy.image
                                        .renderingMode(.original)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: geometry.size.width, height: 400)
                                        .clipped()
                                        .contentShape(TapShape())
                                }
                            }
                            
                        }.frame(width: geometry.size.width, height: 400)
                        .onTouchDown({
                            isOriginalShowing = true
                        }) {
                            isOriginalShowing = false
                            
                        }
                        
                        HStack {
                            
                            HStack {
                                Image(systemName: "arrow.left")
                                    .resizable()
                                    .font(.largeTitle)
                                    .frame(width: 22, height: 22)
                                    .foregroundColor(.white)
                            }
                            
                            .frame(width: 64, height: 400)
                            .contentShape(Rectangle())
                            .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                                if (currentImage != 0) { currentImage -= 1}
                            })
                            Spacer()
                            
                            
                            HStack {
                                Image(systemName: "arrow.right")
                                    .resizable()
                                    .font(.largeTitle)
                                    .frame(width: 22, height: 22)
                                    .foregroundColor(.white)
                            }
                            
                            .frame(width: 64, height: 400)
                            .contentShape(Rectangle())
                            .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                                if (currentImage != filters!.count - 1) { currentImage += 1}
                            })
                            
                        }.frame(width: geometry.size.width)
                        
                        
                    }
                    HStack(alignment: .center) {
                        HStack(alignment: .center) {
                            
                            ForEach((0..<filters!.count), id: \.self) {
                                Circle()
                                    .foregroundColor(currentImage == $0 ? Color(mainColor) : Color.secondary)
                                    
                                    .frame(width: 8)
                            }
                        }.frame(width: geometry.size.width, height: 8).padding(.bottom,8)
                    }
                }
                
                HStack(){
                    Spacer()
                    Text("Hold photo to see without filter") .font(.system(size: 12))
                    Spacer()
                }.sheet(isPresented: $showTutorialSheet) {
                    ScrollView {
                        TutorialView().padding()
                    }
                }
                
                Divider().padding(.bottom, 8).padding(.leading).padding(.trailing)
                
                HStack{
                    Text(filters![currentImage].name).bold()
                    
                    Button(action: {
                        showImageInfo.toggle()
                        
                    }) {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(Color.secondary)
                    }.padding(.leading,4)
                    Spacer()
                    
                    ActivityIndicator(isAnimating: $isLoading, style: .large) /////////////
                    
                    Button(action: {
                        isLoading = true
                        DispatchQueue.main.async {
                            
                            fileurl = getURLtoFile()
                            fetchNearbyPlaces(filterfileurl: filters![currentImage].filterFileURL)
                            
                        }
                        
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
                
                Divider().padding(.bottom, 8).padding(.leading).padding(.trailing)
                
                
                
                
            }.navigationBarItems(trailing:
                                    
                                    HStack(spacing: 20) {
                                        
                                        Button(action: {
                                            
                                            
                                            self.showTutorialSheet = true
                                            print("presented")
                                            
                                        }) {
                                            //Image(systemName: "questionmark.circle")
                                            Text("Help")
                                            
                                        }
                                        .sheet(isPresented: $showImageInfo) {
                                            ImageInfoView(filterItem: filters![currentImage])
                                        }
                                        
                                        
                                    }
            )
            .navigationBarTitle(packItem!.name, displayMode: .large)
        }
        
    }
    
    
    private func fetchNearbyPlaces(filterfileurl: String) {
        print("started fetching url")
        let urlString = filterfileurl
        
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        
        print("before loading data")
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                // we got some data back!
                print("#!#")
                print(data)
                
                
                fileurl = (data.dataToFile(fileName: "filter.dng")?.absoluteString)!
                showShareSheet.toggle()
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

struct TapShape : Shape {
    func path(in rect: CGRect) -> Path {
        return Path(CGRect(x: 0, y: 0, width: rect.width, height: 350))
    }
}

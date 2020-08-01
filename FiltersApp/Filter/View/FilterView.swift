//
//  FilterView.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 30.07.2020.
//

import SwiftUI

struct FilterView: View {
    var filterItem: filter
    @State private var isOriginalShowing = false
    @State private var showShareSheet = false
    
    
    @State private var celsius: Double = 0
    
    @State private var showImageInfo: Bool = false
    
    @State private var fileurl : String?
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ScrollView(.vertical, showsIndicators: false ) {
                VStack(alignment: .leading)
                {
                    
                    HStack{
                        
                        Image(uiImage: isOriginalShowing ? UIImage(data: filterItem.imageBefore!)! : UIImage(data: filterItem.imageAfter!)!
                        )
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width)
                        
                        
                        .onTouchDown({
                            isOriginalShowing = true
                        }) {
                            isOriginalShowing = false
                            
                        }
                    }.navigationBarTitle(filterItem.name, displayMode: .large)
                    
                    
                    HStack(){
                        Spacer()
                        Text("Hold photo to see without filter") .font(.system(size: 12))
                        Spacer()
                    }
                    
                    Divider().padding(.bottom, 8).padding(.leading).padding(.trailing)
                    
                    HStack{
                        Text("#" + (filterItem.tags ?? "Filter")).bold()
                        
                        Button(action: {
                            showImageInfo.toggle()
                            
                        }) {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(Color.secondary)
                        }.padding(.leading,4)
                        Spacer()
                        
                        Button(action: {
                            self.showShareSheet.toggle()
                        }) {
                            Text("  Get filter  ")
                                .font(.system(size: 20))
                                .padding(2)
                                .foregroundColor(Color.primary)
                                .background(Color("BWcolor"))
                                .addBorder(Color.primary, width: 0.8, cornerRadius: 10)
                        }
                    }.padding(.leading,8).padding(.trailing,8).sheet(isPresented: $showShareSheet) {
                        ShareSheet(activityItems: [NSURL(fileURLWithPath: getURLtoFile())])
                    }
                    
                    Divider().padding(.bottom, 8).padding(.leading).padding(.trailing)
                    
                    TutorialView().padding(.leading,8).padding(.trailing, 8)
                    
                }
                
            }
            .navigationBarItems(trailing:
                                    Button(action: {
                                        
                                        
                                        self.showShareSheet = true
                                        print("presented")
                                        
                                    }) {
                                        Image(systemName: "square.and.arrow.up")
                                        
                                    }.sheet(isPresented: $showImageInfo) {
                                        ImageInfoView(filterItem: filterItem)
                                    }
            )
        }
        .onAppear() {
            
            fileurl = getURLtoFile()
            DispatchQueue.main.async {
                fetchNearbyPlaces(filterfileurl: filterItem.filterFileURL)
            }
            
        }
    }
    
    func fetchNearbyPlaces(filterfileurl: String) {
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

struct FilterView_Previews: PreviewProvider {
    
    
    
    static var previews: some View {
        FilterView(filterItem: filter())
    }
}

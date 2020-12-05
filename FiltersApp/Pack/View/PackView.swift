import Foundation
import SwiftUI
import URLImage

struct PackView: View {
    
    var packItem: pack
    var filters: [filter]?
    @Binding var filters_all: [filter]
    
    @State var currentImage = 0
    @State private var isOriginalShowing = false
    @State private var showImageInfo: Bool = false
    @State private var showShareSheet = false
    @State private var fileurl : String?
    @State private var isLoading : Bool = false
    @State private var showTutorialSheet : Bool = false
    @State private var showRelated: Bool = true
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false ) {
                VStack {
                    ZStack(alignment: .bottomLeading) {
                        
                        ZStack(alignment: .leading) {
                            HStack{
                                // if we have images in memory (local) and dont have to load it from server
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
                                else { // we need to load 'after' image from server
                                    URLImage(URL(string: isOriginalShowing ? filters![currentImage].imageBefore: filters![currentImage].imageAfter)!,placeholder: {
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
                                            .frame(width: geometry.size.width, height: 400)
                                            .clipped()
                                            .contentShape(TapShape())
                                    }
                                }
                                
                            }
                            .frame(width: geometry.size.width, height: 400)
                            .onTouchDown({ //swaps before/after images on hold
                                isOriginalShowing = true
                            }) {
                                isOriginalShowing = false
                            }
                            
                            // arrows to swipe fitlers in pack in different directions
                            PackNavigationItems(currentImage: $currentImage, filters: filters)
                                .frame(width: geometry.size.width)
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
                        
                        //displays progress of download
                        ActivityIndicator(isAnimating: $isLoading, style: .large)
                        
                        // by tap .dng file (filter) download starts
                        Button(action: {
                            isLoading = true
                            DispatchQueue.main.async {
                                fileurl = getURLtoFile()
                                downloadFilter(filterfileurl: filters![currentImage].filterFileUrl)
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
                    
                    VStack(alignment: .leading){
                        if (showRelated) {
                            let relatedFilters = filters_all.filter{ HasAnyTag(filter1: $0, filter2: filters![0]) }
                            if relatedFilters.count > 2 {
                                Text("More like this").font(.title).bold().padding(.leading)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(0..<relatedFilters.count) { counter in
                                            NavigationLink(destination: FilterView(filterItem: relatedFilters[counter], filters: $filters_all)) {
                                                FilterPreviewCard(filterItem: relatedFilters[counter]).frame(height: 280).cornerRadius(6).clipped()
                                            }
                                        }
                                    }.padding()
                                    
                                }.frame(height: 250).padding(.bottom, 30)
                            }
                        }
                    }
                }.navigationBarItems(trailing:
                                        HStack(spacing: 20) {
                                            Button(action: {
                                                self.showTutorialSheet = true
                                            }) {
                                                Text("Help")
                                            }
                                            .sheet(isPresented: $showImageInfo) {
                                                ImageInfoView(filterItem: filters![currentImage])
                                            }
                                        })
                .navigationBarTitle(packItem.name, displayMode: .large)
            }
        }
        
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

struct TapShape : Shape {
    func path(in rect: CGRect) -> Path {
        return Path(CGRect(x: 0, y: 0, width: rect.width, height: 350))
    }
}

struct PackNavigationItems: View {
    @Binding var currentImage: Int
    var filters: [filter]?
    
    var body: some View {
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
        }
    }
}

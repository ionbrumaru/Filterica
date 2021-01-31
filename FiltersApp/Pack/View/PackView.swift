import Foundation
import SwiftUI
import URLImage
import RealmSwift
import StoreKit

struct PackView: View {
    
    var packItem: pack
    var filters: [filter]?
    @Binding var filters_all: [filter]
    @State var isLiked: Bool = false
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
    
                                    URLImage(url: URL(string: isOriginalShowing ? filters![currentImage].imageBefore: filters![currentImage].imageAfter)!,
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
                                                    .frame(width: geometry.size.width, height: 400)
                                                    .clipped()
                                                    .contentShape(TapShape())
                                             })
                                }
                                
                            }
                            .frame(width: geometry.size.width, height: 400)
                            .onTouchDown({ //swaps before/after images on hold
                                isOriginalShowing = true
                            }) {
                                isOriginalShowing = false
                            }
                            
                            // arrows to swipe fitlers in pack in different directions
                            PackNavigationItems(isLiked: $isLiked, currentImage: $currentImage, filters: filters)
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
                        
                        LikeButton(isLiked: $isLiked, currentImage: $currentImage, filters: filters)
                        
                        
                        
                        
                        Spacer()
                        
                        //displays progress of download
                        ActivityIndicator(isAnimating: $isLoading, style: .large)
                        
                        Button(action: {
                            showImageInfo.toggle()
                        }) {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(Color.secondary)
                        }.padding(.leading,4)
                        
                        
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
                }.onAppear() {
                    self.adviceReview()
                }
                .navigationBarItems(trailing:
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
                .navigationBarTitle(packItem.name)
            }
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
    @Binding var isLiked: Bool
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
                isLiked = filters![currentImage].liked
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
                isLiked = filters![currentImage].liked
            })
        }
    }
}

struct LikeButton: View {
    @Binding var isLiked: Bool
    @Binding var currentImage: Int
    var filters: [filter]?
    
    var body: some View {
        Image(systemName: "suit.heart.fill")
            .font(Font.system(size: 30, weight: .regular))
            .foregroundColor(isLiked ? Color(UIColor(named: "MainColor")!) : Color.secondary)
            //.padding(.trailing,4)
            .onTapGesture {
                do {
                    var realm = try Realm()
                    
                    if (!isLiked) {
                        print("LIKE")
                        
                        let realmFilters = realm.objects(filter.self).filter("name = %@", filters![currentImage].name)
                        
                        if let fltr = realmFilters.first {
                            try! realm.write {
                                fltr.liked = true
                            }
                        }
                        isLiked = true
                        
                    }
                    else {
                        print("dislike")
                        
                        let realmFilters = realm.objects(filter.self).filter("name = %@", filters![currentImage].name)
                        
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
                isLiked = filters![currentImage].liked
            }
    }
}

import Foundation
import SwiftUI
import URLImage
import RealmSwift
import StoreKit

struct PackView: View {
    @EnvironmentObject var fs: FilterStorage

    var packItem: Pack
    var filters: [filter]?
    @State var currentImage = 0

    @StateObject private var viewModel = PackViewModel()
    
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
                                            UIImage(named: viewModel.isOriginalShowing
                                                    ? filters![currentImage].imageBefore.replacingOccurrences(of: "LOCAL_", with: "")
                                                    : filters![currentImage].imageAfter.replacingOccurrences(of: "LOCAL_", with: ""))!)
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geometry.size.width, height: 400)
                                    .clipped()
                                    .contentShape(TapShape())
                                }
                                else { // we need to load 'after' image from server

                                    URLImage(url: URL(string: viewModel.isOriginalShowing
                                                      ? filters![currentImage].imageBefore
                                                      : filters![currentImage].imageAfter)!,
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
                                viewModel.isOriginalShowing = true
                            }) {
                                viewModel.isOriginalShowing = false
                            }
                            
                            // arrows to swipe fitlers in pack in different directions
                            PackNavigationItems(isLiked: $viewModel.isLiked,
                                                currentImage: $currentImage,
                                                filters: filters)
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
                    }.sheet(isPresented: $viewModel.showTutorialSheet) {
                        ScrollView {
                            TutorialView().padding()
                        }
                    }
                    
                    UnderImageLinedView(filterItem: filters![currentImage],
                                        showShareSheet: $viewModel.showShareSheet,
                                        showImageInfo: $viewModel.showImageInfo,
                                        isLoading: $viewModel.isLoading,
                                        isLiked: filters![currentImage].liked)
                    
                    VStack(alignment: .leading){
                        if (viewModel.showRelated) {
                            let relatedFilters = fs.filters.filter{ HasAnyTag(filter1: $0, filter2: filters![0]) }
                            if relatedFilters.count > 2 {
                                Text("More like this").font(.title).bold().padding(.leading)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(0..<relatedFilters.count) { counter in
                                            NavigationLink(destination: FilterView(filterItem: relatedFilters[counter])) {
                                                FilterPreviewCard(filterItem: relatedFilters[counter]).frame(height: 280).cornerRadius(6).clipped()
                                            }
                                        }
                                    }.padding()
                                    
                                }.frame(height: 250).padding(.bottom, 30)
                            }
                        }
                    }
                }.onAppear() {
                    self.viewModel.adviceReview()
                }
                .navigationBarItems(trailing:
                                        HStack(spacing: 20) {
                    Button(action: {
                        self.viewModel.showTutorialSheet = true
                    }) {
                        Text("Help")
                    }
                    .sheet(isPresented: $viewModel.showImageInfo) {
                        ImageInfoView(filterItem: filters![currentImage])
                    }
                })
                .navigationBarTitle(packItem.name)
            }
        }
        
    }
    
}

struct TapShape : Shape {
    func path(in rect: CGRect) -> Path {
        return Path(CGRect(x: 0, y: 0, width: rect.width, height: 350))
    }
}

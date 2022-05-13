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
    @EnvironmentObject var fs: FilterStorage
    @StateObject private var viewModel = FilterViewModel()

    var filterItem: filter
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ScrollView(.vertical, showsIndicators: false ) {
                VStack(alignment: .leading)
                {
                    
                    HStack{
                        
                        if (filterItem.imageBefore.contains("LOCAL_")) {
                            Image(uiImage: viewModel.isOriginalShowing
                                  ? UIImage(named: filterItem.imageBefore.replacingOccurrences(of: "LOCAL_", with: ""))!
                                  : UIImage(named: filterItem.imageAfter.replacingOccurrences(of: "LOCAL_", with: ""))!
                            )
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: 350)
                            .clipped()
                        }
                        else {
                            
                            URLImage(url: URL(string: viewModel.isOriginalShowing
                                              ? filterItem.imageBefore
                                              : filterItem.imageAfter)!,
                                     options: URLImageOptions(
                                        cachePolicy: .returnCacheElseLoad(cacheDelay: nil, downloadDelay: 0.25)
                                     ),
                                     empty: {
                                Text("nothing")
                            },
                                     inProgress: { progress in
                                VStack(alignment: .center) {
                                    if #available(iOS 14.0, *) {

                                        ProgressView()

                                    } else {
                                        ActivityIndicator(isAnimating: .constant(true), style: .large)

                                    }
                                }.frame(width: 330, height: 300)

                            },
                                     failure: { error, retry in
                                VStack {
                                    Text(error.localizedDescription)
                                    Button("Retry", action: retry)
                                }
                            },
                                     content: { image in
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
                            viewModel.isOriginalShowing = true

                        }) {
                            viewModel.isOriginalShowing = false
                        }
                    
                    HStack(){
                        Spacer()
                        Text("Hold photo to see without filter") .font(.system(size: 12))
                        Spacer()
                    }
                    
                    UnderImageLinedView(filterItem: filterItem,
                                        showShareSheet: $viewModel.showShareSheet,
                                        showImageInfo: $viewModel.showImageInfo,
                                        isLoading: $viewModel.isLoading)
                    
                    if (viewModel.showRelated) {
                        let relatedFilters = fs.filters.filter{ HasAnyTag(filter1: $0, filter2: filterItem) }
                        
                        if relatedFilters.count > 2 {
                            Text("More like this").font(.title).bold().padding(.leading)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(0 ..< relatedFilters.count) { counter in
                                        NavigationLink(destination: FilterView(filterItem: relatedFilters[counter])) {
                                            FilterPreviewCard(filterItem: relatedFilters[counter]).frame(height: 280).cornerRadius(6).clipped()
                                        }
                                    }
                                }.padding()
                                
                            }.frame(height: 250).padding(.bottom, 30)
                        }
                    }
                    
                    if (viewModel.showTutorial){
                        Divider().padding(.bottom, 4).padding(.leading).padding(.trailing).padding(.top, 4)
                        TutorialView().padding(.leading,8).padding(.trailing, 8)
                    }
                    
                }
                .onAppear() {
                    self.viewModel.adviceReview()
                }
            }
            .navigationBarItems(trailing: HStack(spacing: 20) {
                Button(action: {
                    self.viewModel.showTutorialSheet = true
                }) {
                    Text("Help")
                }.sheet(isPresented: $viewModel.showTutorialSheet) {
                    ScrollView {
                        TutorialView().padding()
                    }
                }

                Button(action: {
                    self.viewModel.showShareSheet = true
                    print("presented")

                }) {
                    Image(systemName: "square.and.arrow.up")

                }.disabled(viewModel.isShareButtonDisabled)
                    .sheet(isPresented: $viewModel.showImageInfo) {
                        ImageInfoView(filterItem: filterItem)
                    }
            })
        }
    }
}


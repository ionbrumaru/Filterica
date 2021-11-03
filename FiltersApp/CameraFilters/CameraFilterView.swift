import SwiftUI
import URLImage
@available(iOS 14.0, *)
struct CameraFilterView: View {
    @EnvironmentObject var fs: FilterStorage

    @StateObject var homeData = HomeViewModel()
    @State private var showingAlert = false
    @State private var filters: [filter] = []

    @State var range: Range<Int> = 0 ..< 5
    var body: some View {
        
        VStack{
            
            if homeData.mainView != nil {
                
                Spacer(minLength: 0)
                
                Image(uiImage: homeData.mainView.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width)
                
                Slider(value: $homeData.value)
                    .padding()
                    .opacity(homeData.mainView.isEditable ? 1 : 0)
                    .disabled(homeData.mainView.isEditable ? false : true)
                
                Divider().padding(.leading).padding(.trailing)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack(alignment: .center) {
                        HStack(alignment: .center) {
                            ForEach(range, id: \.self) {index in
                                let filterItem = filters[index]

                                if let url = URL(string: filterItem.imageAfter) {
                                    URLImage(url: url,
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
                                            .frame(width:150 , height: 150)
                                            .clipped()
                                            .onTapGesture {
                                                homeData.loadFilter(settings: filterItem.settings)
                                            }
                                    })
                                }
                            }

                            Button(action: loadMore) {
                                            Text("Load more")
                                        }
                        }
                    }
                }.frame(height: 150)
            }
            else if homeData.imageData.count == 0{
                Button(action: {homeData.imagePicker.toggle()}) {
                    
                    HStack {
                        Image(systemName: "photo")
                            .font(.title2)
                        Text("Pick An Image To Process")
                    }
                }
                
            }
            else{
                // Loading View...
                ProgressView()
            }
        }
        .onAppear {
            filters = fs.filters.filter{!$0.imageBefore.contains("LOCAL_") }
        }
        //        .onChange(of: homeData.value, perform: { (_) in
        //            homeData.updateEffect()
        //        })
        .onChange(of: homeData.imageData, perform: { (_) in
            // When Ever image is changed Firing loadImage...
            
            // clearing exisiting data...
//            homeData.allImages.removeAll()
            homeData.mainView = FilteredImage(name: "", image: UIImage(data: homeData.imageData)!, filter: CIFilter(), isEditable: true)
        })
        .toolbar {
            // Saving Image....
            
            ToolbarItem(placement: .navigationBarTrailing) {
                
                Button(action: {
                    UIImageWriteToSavedPhotosAlbum(homeData.mainView.image, nil, nil, nil)
                    showingAlert = true
                }) {
                    
                    Text("Save")
                        .font(.title2)
                }
                // disabling on no Image...
                .disabled(homeData.mainView == nil ? true : false)
            }
        }
        .sheet(isPresented: $homeData.imagePicker) {
            
            ImagePicker(picker: $homeData.imagePicker, imageData: $homeData.imageData)
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Success"), message: Text("Photo was saved to your library"), dismissButton: .default(Text("Got it!")))
        }
    }

    func loadMore() {
            print("Load more...")
            self.range = 0..<self.range.upperBound + 5
        }
}


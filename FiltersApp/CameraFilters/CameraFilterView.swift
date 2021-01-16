import SwiftUI

struct CameraFilterView: View {
    @StateObject var homeData = HomeViewModel()
    @State private var showingAlert = false
    var body: some View {
        
        VStack{
            
            if !homeData.allImages.isEmpty && homeData.mainView != nil{
                
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
                    
                    HStack(spacing: 20){
                        
                        ForEach(homeData.allImages){filtered in
                            
                            VStack {
                            Image(uiImage: filtered.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 150)
                            // Updating ManView...
                            // WhenEver Button Tapped...
                                .onTapGesture {
                                    // clearing old data...
                                    homeData.value = 1.0
                                    homeData.mainView = filtered
                                }
                                
                                Text(filtered.name.replacingOccurrences(of: "CI", with: ""))
                            }
                        }
                    }
                    .padding()
                }
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
        .onChange(of: homeData.value, perform: { (_) in
            homeData.updateEffect()
        })
        .onChange(of: homeData.imageData, perform: { (_) in
            // When Ever image is changed Firing loadImage...
            
            // clearing exisiting data...
            homeData.allImages.removeAll()
            homeData.mainView = nil
            homeData.loadFilter()
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
}


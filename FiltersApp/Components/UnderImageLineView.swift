//
//  UnderImageLineView.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 02.02.2021.
//

import SwiftUI
import RealmSwift

struct UnderImageLinedView: View {
    var filterItem: filter
    
    @Binding var showShareSheet: Bool
    @Binding var showImageInfo: Bool
    @Binding var isLoading: Bool
    
    @State private var fileurl : String?
    @State var isLiked = false
    
    let getfiltertext: LocalizedStringKey =  "  Get filter  "
    
    var realm = try! Realm()
    
    var body: some View {
        Divider().padding(.bottom, 2).padding(.leading).padding(.trailing)
        
        HStack{
            Text("#" + (filterItem.tags ?? "Filter")).bold()
            
            Image(systemName: "suit.heart.fill")
                .font(Font.system(size: 30, weight: .regular))
                .foregroundColor(isLiked ? Color(UIColor(named: "MainColor")!) : Color.secondary)
                .onTapGesture {
                    if (!isLiked) {
                        let realmFilters = realm.objects(filter.self).filter("name = %@", filterItem.name)
                        
                        if let fltr = realmFilters.first {
                            try! realm.write {
                                fltr.liked = true
                            }
                        }
                        isLiked = true
                    }
                    else {
                        let realmFilters = realm.objects(filter.self).filter("name = %@", filterItem.name)
                        
                        if let fltr = realmFilters.first {
                            try! realm.write {
                                fltr.liked = false
                            }
                        }
                        isLiked = false
                    }
                    
                    
                }.onAppear() {
                    isLiked = filterItem.liked
                }
            
            Spacer()
            
            ActivityIndicator(isAnimating: $isLoading, style: .large)
            
            Button(action: {
                showImageInfo.toggle()
                
            }) {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(Color.secondary)
            }.padding(.leading,4)
            
            Button(action: {
                isLoading = true
                DispatchQueue.main.async {
                    fileurl = getURLtoFile()
                    downloadFilter(filterfileurl: filterItem.filterFileUrl)
                }
            }) {
                Text(getfiltertext)
                    .font(.system(size: 20))
                    .padding(2)
                    .foregroundColor(Color.white)
                    .background(Color(mainColor))
                    .cornerRadius(10)
            }
        }.padding(.leading,8).padding(.trailing,8).sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: [NSURL(fileURLWithPath: getURLtoFile())])
        }
        
        Divider()
            .padding(.bottom, 4)
            .padding(.horizontal)
    }
    
    private func downloadFilter(urlString: String) {        
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, 
                let absoluteString = data.dataToFile(fileName: "filter.dng")?.absoluteString {
                fileurl = absoluteString
                showShareSheet.toggle()
                isLoading = false
            } else {
                fileurl = nil
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

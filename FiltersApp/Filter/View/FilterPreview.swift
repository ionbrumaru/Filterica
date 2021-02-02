//
//  FilterPreview.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 30.07.2020.
//

import SwiftUI
import URLImage

struct FilterPreviewCard: View {
    var filterItem: filter
    
    var body: some View {
        VStack(alignment: .leading) {
            if (filterItem.imageAfter.contains("LOCAL_")) {
                Image(uiImage: UIImage(named: filterItem.imageAfter.replacingOccurrences(of: "LOCAL_", with: ""))!
                )
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 330, height: 300)
                .cornerRadius(12)
            }
            else {
                
                URLImage(url: URL(string: filterItem.imageAfter)!,
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
                                .frame(width: 330, height: 300)
                                .cornerRadius(12)
                         })
            }
            
            HStack{
                Text(filterItem.name.capitalizingFirstLetter()).bold().padding(.leading, 4).foregroundColor(Color.primary)
                Spacer()
            }
        }
    }
}


struct FilterPreview_Previews: PreviewProvider {
    static var previews: some View {
        
        FilterPreviewCard(filterItem: filter())
    }
}

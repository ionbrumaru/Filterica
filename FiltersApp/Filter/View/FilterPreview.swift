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
                URLImage(URL(string: filterItem.imageAfter)!, delay: 0.25,placeholder: {
                    ProgressView($0) { progress in
                        ZStack {
                            if progress >= 0.0 {
                                // The download has started. CircleProgressView displays the progress.
                                CircleProgressView(progress)
                                    .stroke(lineWidth: 8.0)
                            }
                        }
                    }
                    .frame(width: 50.0, height: 50.0)
                }) { proxy in
                    proxy.image
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 330, height: 300)
                        .cornerRadius(12)
                }
            }
            
            HStack{
                Text(filterItem.name.capitalizingFirstLetter()).bold().padding(.leading, 4).foregroundColor(Color.primary)
                Spacer()
            }
        }
    }
    
    
    func redacted(when active: Bool) -> some View {
        return active ? AnyView(redacted(reason: .placeholder)) : AnyView(unredacted())
    }
}


struct FilterPreview_Previews: PreviewProvider {
    static var previews: some View {
        
        FilterPreviewCard(filterItem: filter())
    }
}

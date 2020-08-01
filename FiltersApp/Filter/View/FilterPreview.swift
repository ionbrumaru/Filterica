//
//  FilterPreview.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 30.07.2020.
//

import SwiftUI

struct FilterPreviewCard: View {
    var filterItem: filter
    var body: some View {
        VStack(alignment: .leading) {
            Image(uiImage: UIImage(data: filterItem.imageAfter!)!
            )
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 330, height: 240)
            .cornerRadius(12)
            
            HStack{
                Text(filterItem.name).bold().padding(.leading, 4).foregroundColor(Color.primary)
                Spacer()
                Text("#" + (filterItem.tags ?? "Filter")).font(.footnote).foregroundColor(Color.primary).opacity(0.8)
            }
        }
    }
}

struct FilterPreview_Previews: PreviewProvider {
    static var previews: some View {
        FilterPreviewCard(filterItem: filter())
    }
}

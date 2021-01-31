//
//  FiltersCategory.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 31.07.2020.
//

import SwiftUI

struct FiltersCategory: View {
    var categoryName: String
    var categoryImage: Image
    
    var body: some View {
        VStack(alignment: .center) {
            categoryImage
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 64, height: 64)
                .cornerRadius(360)
            
            HStack(alignment: .center){
                Text(categoryName)
                    //.padding(.leading, 4)
                    .foregroundColor(Color.primary)
            }
        }
    }
}

struct FiltersCategory_Previews: PreviewProvider {
    static var previews: some View {
        FiltersCategory(categoryName: "Summertime chill", categoryImage: Image(uiImage: UIImage(named: "test")!))
    }
}

//
//  FilterView.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 30.07.2020.
//

import SwiftUI

struct FilterView: View {
    var filterItem: filter
    @State private var isOriginalShowing = false
    @State private var tipTextHide = false
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack(alignment: .center)
        {

                Divider()

                
            HStack{
                
                
                ZStack(alignment: .topLeading){
                    
                Image(uiImage: isOriginalShowing ? UIImage(data: filterItem.imageBefore!)! : UIImage(data: filterItem.imageAfter!)!
                )
                .resizable()
                .frame(height: geometry.size.height / 2)
                .scaledToFit()
                
                .cornerRadius(6)
                    Text(tipTextHide ? "" : "tap to see original").font(.caption2).bold()
                }
 
            
                .onTouchDown({
                    isOriginalShowing = true
                                        }) {
                    isOriginalShowing = false

            }
            }.navigationBarTitle(filterItem.name, displayMode: .large)
            
            
            
            HStack{
                Text(filterItem.tags ?? "").bold().opacity(0.7)
                Spacer()
                
                Link(destination: URL(string: filterItem.filterFileURL)!) {
                Text("  Get filter  ")
                    .font(.system(size: 20))
                        .padding(2)
                        .foregroundColor(Color.primary)
                        .background(Color("BWcolor"))
                    .addBorder(Color.primary, width: 0.8, cornerRadius: 10)
                
                }
            }.padding(.leading,8).padding(.trailing,8)
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                self.tipTextHide.toggle()
            }
        }
    }
    }
}

struct FilterView_Previews: PreviewProvider {

    
    
    static var previews: some View {
        FilterView(filterItem: filter())
    }
}

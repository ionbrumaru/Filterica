//
//  imageInfoView.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 01.08.2020.
//

import SwiftUI


struct ImageInfoView: View {
    var filterItem: filter
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                
                Text("LIGHT").bold()
                LightSettingsView(filterItem: filterItem)
                
                Text("COLOR").bold()
                ColorSettingsView(filterItem: filterItem)
                
                Text("EFFECTS").bold()
                EffectsSettingsView(filterItem: filterItem)
                
                Text("DETAIL").bold()
                DetailSettingsView(filterItem: filterItem)
                
            }.padding()
        }
    }
}


struct LightSettingsView: View {
    var filterItem: filter
    var body: some View {
        VStack(spacing: 4) {
            
            VStack{
                HStack {
                    Text("Exposure")
                    Spacer()
                    Text(" \(filterItem.settings!.exposure)" )
                }
                Divider()
            }
            
            VStack{
                HStack {
                    Text("Contrast")
                    Spacer()
                    Text(" \(filterItem.settings!.contrast)" )
                }
                
                Divider()
            }
            
            VStack{
                HStack {
                    Text("Highlights")
                    Spacer()
                    Text(" \(filterItem.settings!.contrast)" )
                }
                Divider()
            }
            
            VStack{
                HStack {
                    Text("Shadows")
                    Spacer()
                    Text(" \(filterItem.settings!.shadows)" )
                }
                
                Divider()
            }
            
            VStack{
                HStack {
                    Text("Whites")
                    Spacer()
                    Text(" \(filterItem.settings!.whites)" )
                }
                
                Divider()
            }
            
            VStack{
                HStack {
                    Text("Blacks")
                    Spacer()
                    Text(" \(filterItem.settings!.blacks)" )
                }
                Divider()
            }
            
        }.padding(.top,6)
    }
}


struct ColorSettingsView: View {
    var filterItem: filter
    var body: some View {
        VStack(spacing: 4) {
            
            VStack{
                HStack {
                    Text("Temperature")
                    Spacer()
                    Text(" \(filterItem.settings!.temperature)" )
                }
                Divider()
            }
            
            VStack{
                HStack {
                    Text("Tint")
                    Spacer()
                    Text(" \(filterItem.settings!.tint)" )
                }
                
                Divider()
            }
            
            VStack{
                HStack {
                    Text("Vibrance")
                    Spacer()
                    Text(" \(filterItem.settings!.vibrance)" )
                }
                Divider()
            }
            
            VStack{
                HStack {
                    Text("Saturation")
                    Spacer()
                    Text(" \(filterItem.settings!.saturation)" )
                }
                
                Divider()
            }
            
            
        }.padding(.top,6)
    }
}

struct EffectsSettingsView: View {
    var filterItem: filter
    var body: some View {
        VStack(spacing: 4) {
            
            VStack{
                HStack {
                    Text("Texture")
                    Spacer()
                    Text(" \(filterItem.settings!.texture)" )
                }
                Divider()
            }
            
            VStack{
                HStack {
                    Text("Clarity")
                    Spacer()
                    Text(" \(filterItem.settings!.clarity)" )
                }
                
                Divider()
            }
            
            VStack{
                HStack {
                    Text("Dehaze")
                    Spacer()
                    Text(" \(filterItem.settings!.dehaze)" )
                }
                Divider()
            }
            
            VStack{
                HStack {
                    Text("Vignette")
                    Spacer()
                    Text(" \(filterItem.settings!.vignette)" )
                }
                
                Divider()
            }
            
            
            VStack{
                HStack {
                    Text("Grain")
                    Spacer()
                    Text(" \(filterItem.settings!.grain)" )
                }
                
                Divider()
            }
            
            
            VStack{
                HStack {
                    Text("Size")
                    Spacer()
                    Text(" \(filterItem.settings!.size)" )
                }
                
                Divider()
            }
            
            VStack{
                HStack {
                    Text("Roughness")
                    Spacer()
                    Text(" \(filterItem.settings!.roughness)" )
                }
                
                Divider()
            }
            
        }.padding(.top,6)
    }
}

struct DetailSettingsView: View {
    var filterItem: filter
    var body: some View {
        VStack(spacing: 4) {
            
            VStack{
                HStack {
                    Text("Sharpening")
                    Spacer()
                    Text(" \(filterItem.settings!.sharpening)" )
                }
                Divider()
            }
            
            VStack{
                HStack {
                    Text("Radius")
                    Spacer()
                    Text(" \(filterItem.settings!.radius)" )
                }
                
                Divider()
            }
            
            VStack{
                HStack {
                    Text("Detail")
                    Spacer()
                    Text(" \(filterItem.settings!.detail)" )
                }
                Divider()
            }
            
            VStack{
                HStack {
                    Text("Masking")
                    Spacer()
                    Text(" \(filterItem.settings!.masking)" )
                }
                
                Divider()
            }
            
            
        }.padding(.top,6)
    }
}

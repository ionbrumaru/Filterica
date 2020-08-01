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
                Text(" \(filterItem.filterSettings!.exposure)" )
            }
            Divider()
            }
            
            VStack{
            HStack {
                Text("Contrast")
                Spacer()
                Text(" \(filterItem.filterSettings!.contrast)" )
            }
            
            Divider()
            }
            
            VStack{
            HStack {
                Text("Highlights")
                Spacer()
                Text(" \(filterItem.filterSettings!.contrast)" )
            }
            Divider()
            }
            
            VStack{
            HStack {
                Text("Shadows")
                Spacer()
                Text(" \(filterItem.filterSettings!.shadows)" )
            }
            
            Divider()
            }
            
            VStack{
            HStack {
                Text("Whites")
                Spacer()
                Text(" \(filterItem.filterSettings!.whites)" )
            }
            
            Divider()
            }
            
            VStack{
            HStack {
                Text("Blacks")
                Spacer()
                Text(" \(filterItem.filterSettings!.blacks)" )
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
                Text(" \(filterItem.filterSettings!.temperature)" )
            }
            Divider()
            }
            
            VStack{
            HStack {
                Text("Tint")
                Spacer()
                Text(" \(filterItem.filterSettings!.tint)" )
            }
            
            Divider()
            }
            
            VStack{
            HStack {
                Text("Vibrance")
                Spacer()
                Text(" \(filterItem.filterSettings!.vibrance)" )
            }
            Divider()
            }
            
            VStack{
            HStack {
                Text("Saturation")
                Spacer()
                Text(" \(filterItem.filterSettings!.saturation)" )
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
                Text(" \(filterItem.filterSettings!.texture)" )
            }
            Divider()
            }
            
            VStack{
            HStack {
                Text("Clarity")
                Spacer()
                Text(" \(filterItem.filterSettings!.clarity)" )
            }
            
            Divider()
            }
            
            VStack{
            HStack {
                Text("Dehaze")
                Spacer()
                Text(" \(filterItem.filterSettings!.dehaze)" )
            }
            Divider()
            }
            
            VStack{
            HStack {
                Text("Vignette")
                Spacer()
                Text(" \(filterItem.filterSettings!.vignette)" )
            }
            
            Divider()
            }
            
            
            VStack{
            HStack {
                Text("Grain")
                Spacer()
                Text(" \(filterItem.filterSettings!.grain)" )
            }
            
            Divider()
            }
            
            
            VStack{
            HStack {
                Text("Size")
                Spacer()
                Text(" \(filterItem.filterSettings!.size)" )
            }
            
            Divider()
            }
            
            VStack{
            HStack {
                Text("Roughness")
                Spacer()
                Text(" \(filterItem.filterSettings!.roughness)" )
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
                Text(" \(filterItem.filterSettings!.sharpening)" )
            }
            Divider()
            }
            
            VStack{
            HStack {
                Text("Radius")
                Spacer()
                Text(" \(filterItem.filterSettings!.radius)" )
            }
            
            Divider()
            }
            
            VStack{
            HStack {
                Text("Detail")
                Spacer()
                Text(" \(filterItem.filterSettings!.detail)" )
            }
            Divider()
            }
            
            VStack{
            HStack {
                Text("Masking")
                Spacer()
                Text(" \(filterItem.filterSettings!.masking)" )
            }
            
            Divider()
            }
            
            
        }.padding(.top,6)
    }
}

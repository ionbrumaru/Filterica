//
//  Data.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 30.07.2020.
//

import RealmSwift

//let realmData = try! Realm()
let mainColor = UIColor(named: "MainColor")!

let localFiters: [filter] = [
    
    filter(name: "Barberry", filterDescription: "", tags: "Atmosphere", filterFileURL: "https://kazantsev-ef.ru/ios/filters/Barberry/Barberry_filter.dng", imageBefore:  "LOCAL_Barberry_before", imageAfter: "LOCAL_Barberry_after", filterSettings:
            imageSettings(exposure: 0, contrast: -11, highlights: -14, shadows: -7, whites: 12, blacks: -8, temperature: 0, tint: 0, vibrance: 0, saturation: -30, texture: 0, clarity: 0, dehaze: 0, vignette: 0, grain: 23, size: 15, roughness: 50, sharpening: 20, radius: 1, detail: 31, masking: 0), isInPack: 0),
    
    filter(name: "Caffeinated", filterDescription: "", tags: "Atmosphere", filterFileURL: "https://kazantsev-ef.ru/ios/filters/Caffeinated/Caffeinated_filter.dng", imageBefore:  "LOCAL_Caffeinated_before", imageAfter:  "LOCAL_Caffeinated_after", filterSettings:
            imageSettings(exposure: 0.24, contrast: 6, highlights: -100, shadows: 76, whites: -100, blacks: 65, temperature: 11, tint: 1, vibrance: -8, saturation: -25, texture: 0, clarity: 0, dehaze: 0, vignette: 0, grain: 0, size: 25, roughness: 50, sharpening: 0, radius: 1, detail: 11, masking: 29), isInPack: 0),
    
    filter(name: "Comfy home", filterDescription: "", tags: "Atmosphere", filterFileURL: "https://kazantsev-ef.ru/ios/filters/Comfy_home/Comfy_home_filter.dng", imageBefore:  "LOCAL_Comfy home_before", imageAfter:  "LOCAL_Comfy home_after", filterSettings:
            imageSettings(exposure: 0.20, contrast: -11, highlights: -50, shadows: 53, whites: 25, blacks: 30, temperature: 17, tint: -13, vibrance: 19, saturation: -4, texture: 0, clarity: 0, dehaze: 0, vignette: 0, grain: 0, size: 25, roughness: 50, sharpening: 30, radius: 1, detail: 24, masking: 0), isInPack: 0),
    
    filter(name: "Florida", filterDescription: "", tags: "Summer", filterFileURL: "https://kazantsev-ef.ru/ios/filters/Florida/Florida_filter.dng", imageBefore:  "LOCAL_Florida_before", imageAfter:  "LOCAL_Florida_after", filterSettings:
            imageSettings(exposure: 0.30, contrast: 0, highlights: -30, shadows: 50, whites: -30, blacks: 74, temperature: 0, tint: 0, vibrance: 18, saturation: -25, texture: 0, clarity: 10, dehaze: 0, vignette: 0, grain: 3, size: 25, roughness: 50, sharpening: 25, radius: 1, detail: 25, masking: 0), isInPack: 0),
    
    filter(name: "Hygge vibes", filterDescription: "", tags: "Atmosphere", filterFileURL: "https://kazantsev-ef.ru/ios/filters/Hygge_vibes/Hygge_vibes_filter.dng", imageBefore:  "LOCAL_Hygge vibes_before", imageAfter:  "LOCAL_Hygge vibes_after", filterSettings:
            imageSettings(exposure: 0.57, contrast: 23, highlights: -100, shadows: 87, whites: -41, blacks: 99, temperature: 18, tint: -59, vibrance: -50, saturation: -7, texture: 0, clarity: 20, dehaze: 25, vignette: 0, grain: 0, size: 25, roughness: 50, sharpening: 0, radius: 1, detail: 25, masking: 0), isInPack: 0),
    
    filter(name: "Misty rose", filterDescription: "", tags: "Urban, Color", filterFileURL: "https://kazantsev-ef.ru/ios/filters/Misty_rose/Misty_rose_filter.dng", imageBefore:  "LOCAL_Misty rose_before", imageAfter:  "LOCAL_Misty rose_after", filterSettings:
            imageSettings(exposure: 0.25, contrast: -17, highlights: -91, shadows: 16, whites: -79, blacks: 35, temperature: 17, tint: 7, vibrance: 27, saturation: -21, texture: 0, clarity: 40, dehaze: 0, vignette: 2, grain: 5, size: 25, roughness: 29, sharpening: 17, radius: 1, detail: 13, masking: 0), isInPack: 0),
    
    filter(name: "Orange and teal", filterDescription: "", tags: "Color", filterFileURL: "https://kazantsev-ef.ru/ios/filters/Orange_and_teal/Orange_and_teal_filter.dng", imageBefore:  "LOCAL_Orange and teal_before", imageAfter:  "LOCAL_Orange and teal_after", filterSettings:
            imageSettings(exposure: -0.95, contrast: -26, highlights: -71, shadows: 82, whites: -40, blacks: -22, temperature: 9, tint: -22, vibrance: 0, saturation: -21, texture: 0, clarity: 0, dehaze: 0, vignette: 0, grain: 0, size: 25, roughness: 50, sharpening: 54, radius: 1, detail: 25, masking: 0), isInPack: 0),
    
    filter(name: "Orange and teal 2", filterDescription: "", tags: "Color", filterFileURL: "https://kazantsev-ef.ru/ios/filters/Orange_and_teal/Orange_and_teal_2_filter.dng", imageBefore:  "LOCAL_Orange and teal 2_before", imageAfter:  "LOCAL_Orange and teal 2_after", filterSettings:
            imageSettings(exposure: -0.25, contrast: -26, highlights: -71, shadows: 83, whites: -60, blacks: 13, temperature: 9, tint: -22, vibrance: 0, saturation: -21, texture: 0, clarity: 0, dehaze: 0, vignette: 0, grain: 0, size: 25, roughness: 50, sharpening: 54, radius: 1, detail: 25, masking: 0), isInPack: 0),
    
    filter(name: "Pinky teal", filterDescription: "", tags: "Summer,Color", filterFileURL: "https://kazantsev-ef.ru/ios/filters/Pinky_teal/Pinky_teal_filter.dpg", imageBefore:  "LOCAL_Pinky teal_before", imageAfter:  "LOCAL_Pinky teal_after", filterSettings:
            imageSettings(exposure: -0.25, contrast: -26, highlights: -71, shadows: 83, whites: -60, blacks: 13, temperature: 9, tint: -22, vibrance: 0, saturation: -21, texture: 0, clarity: 0, dehaze: 0, vignette: 0, grain: 0, size: 25, roughness: 50, sharpening: 54, radius: 1, detail: 25, masking: 0), isInPack: 0),
    
    filter(name: "Summer rocks", filterDescription: "", tags: "Summer", filterFileURL: "https://kazantsev-ef.ru/ios/filters/Summer_rocks/Summer_rocks_filter.dng", imageBefore:  "LOCAL_Summer rocks_before", imageAfter:  "LOCAL_Summer rocks_after", filterSettings:
            imageSettings(exposure: 0.45, contrast: -26, highlights: -47, shadows: 20, whites: -88, blacks: 23, temperature: 36, tint: -3, vibrance: 24, saturation: -9, texture: 0, clarity: -3, dehaze: 0, vignette: 0, grain: 0, size: 25, roughness: 50, sharpening: 34, radius: 1, detail: 25, masking: 0), isInPack: 0),
    
    filter(name: "Late summer", filterDescription: "", tags: "Summer", filterFileURL: "https://kazantsev-ef.ru/ios/filters/Late_summer/Late_summer_filter.dng", imageBefore:  "LOCAL_Late summer_before", imageAfter:  "LOCAL_Late summer_after", filterSettings:
            imageSettings(exposure: 0.3, contrast: -10, highlights: -50, shadows: 45, whites: -26, blacks: 10, temperature: 6, tint: -3, vibrance: 10, saturation: 0, texture: 0, clarity: 15, dehaze: 0, vignette: 0, grain: 0, size: 25, roughness: 50, sharpening: 0, radius: 1, detail: 44, masking: 0), isInPack: 0),
]

let localPacks: [pack] = []
var serverPacks: [pack] = []

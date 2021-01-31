//
//  Data.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 30.07.2020.
//
import SwiftUI
import RealmSwift

//let realmData = try! Realm()
let mainColor = UIColor(named: "MainColor")!


let localAdvices: [advice] = [
    advice(id: 0, name: "Adjust White Balance", text: """
Have you ever looked at one of your pictures taken in the bright sunlight, wishing it had a blue tint?
           
They are still no match for your eyes for all of the advances of digital cameras. Your eyes automatically change if you see some scene in front of you so that we see a perfect image in natural color.

Unfortunately, digital cameras are unable to do so, so it is always important to tweak your pictures to catch the scene as you would have seen it.

Two approaches to correct white balance:

- You can correct the White Balance while taking a photo
- In post-production.

For example, you can change the White Balance manually if you are photographing in a controlled environment like a studio where the light will be all the same. But this might not be useful when you are out and about and might mean missing the crucial moment.

Two sliders are available that you can change: "Temperature" and "Tint"

The temperature determines how warm or cold the picture feels  (yellow or blue), and tint adds green or magenta (a pinkish tone). By combining these you’ll be able to get a natural look for your images.
""", imageName: "Comfy home_after"),
    
    advice(id: 1, name: "Adjust the Highlights and Shadows", text:
           """
        Often, the most popular feedback I offer when I review work from aspiring photographers is that their highlights (whites) or shadows (blacks) look like they're clipped.

        This implies that in that area there are no pixel specifics, so the picture has either pure white or black areas.

        You should preferably try to avoid large areas where this clipping occurs. To allow you to recover these most of the time, Lightroom has a pretty good feature.

        There are of course occasions when the clipping is so severe that it can’t be recovered. This is especially possible in highlights. But even in dark areas where your shadows are clipped, brightening up those areas too much will leave you with excessive noise.

        So the best solution for avoiding your highlights or shadows getting clipped is to get it right when taking the photo. But most of the time there is the option of doing it in Lightroom.
        """
        , imageName: "Misty rose_before"),
    
    advice(id: 2, name: "Adjust the Vibrance and Saturation", text: """
By boosting their colors, these neat tools in Lightroom will really make your images pop.

If and how much you use the Vibrance and Saturation sliders will depend on your personal taste, preferences, your subject, and how much the photo needs.

For example, for a sunset landscape shot you may want to boost the colors to give your image that wow factor. Whereas a portrait of someone might only need a very subtle boost.

Simply move the sliders along until you get the desired effect. Just be careful not to overdo it as too much saturation will make the image look fake.
""", imageName: "Hygge vibes_before"),
    
    advice(id: 3, name: "Tweak the Contrast", text: """
If you find that your image looks flat, often a good remedy is to tweak the contrast.

There are several ways to do this in Lightroom. First is the Contrast slider in the tone section.

Simply move the slider to the right to increase (or left to decrease) the contrast in the image. If you want more control, check out the Tone Curve section. You can either move the sliders or the line on the graph at various points to create the level of contrast that your image needs.
""", imageName: "Orange and teal_after"),
    
    advice(id: 4, name: "Straighten and Crop", text: """
If you do nothing else to a photo in the post-processing stage, the one thing that you should always do is ensure that it is straight.

This is especially apparent in any image that has a vertical or horizontal line such as a horizon in a landscape image. You should also look to fix images of buildings that suffer from converging lines (where the building looks like it’s falling over).

The latest version of Lightroom (Classic CC) has a good Auto option to straighten your image and fix uprights. Sometimes it needs tweaking or doing manually but in the vast majority of cases, it works well.
""", imageName: "Summer rocks_after"),
    
    advice(id: 5, name: "Dodge and Burn", text:
"""
Sometimes you will find that a certain area of the image can benefit from brightening up or darkening. For example, it might be that you want to brighten a person in your scene while not changing the overall image.

Using the traditional sliders will brighten the entire image, these are called global adjustments. But if you select the Adjustment Brush (hit K on your keyboard to activate it) located under the histogram on the right-hand side, you can then selectively dodge (lighten) and burn (darken) only certain areas. These are called local adjustments.

Dial in the adjustments you want to make, the brush settings (keep the feather number high to blend the changes more naturally), and the brush opacity (keep it low to apply edits gradually just like if you were painting). Then simply adjust the brush to the size you need and go over the area that you want to brighten or darken with your mouse clicked.
""", imageName: "Late summer_after"),
    
    advice(id: 6, name: "Remove Dust Particles", text:
"""
No matter how much you clean your lenses, there will always be occasions where you will end up with dust particles on the sensor or lens glass. These are especially evident in flat color areas like the sky. This is one of the main reasons that you should always check your work by reviewing it on your screen at 100%.

Select the Spot Removal tool (keyboard shortcut is Q) then click on the spot in your image.

Lightroom will automatically remove it by cloning another area onto the spot. You can adjust the source area (where it is cloning from) from by moving the circle that appears.

Note: You can also choose either Clone or Heal for this tool. Cloning is an exact copy of the source area, Heal attempts to blend the area you are fixing with its surroundings so you usually get a nicer, more natural looking result this way. 
""", imageName: "Florida_after")
]

let localFiters: [filter] = [
    
    filter(name: "Barberry", tags: "atmosphere", filterFileURL: "https://kazantsev-ef.ru/ios/filters/Barberry/Barberry_filter.dng", imageBefore:  "LOCAL_Barberry_before", imageAfter: "LOCAL_Barberry_after", filterSettings:
            imageSettings(exposure: "0", contrast: "-11", highlights: "-14", shadows: "-7", whites: "12", blacks: "-8", temperature: "0", tint: "0", vibrance: "0", saturation: "-30", texture: "0", clarity: "0", dehaze: "0", vignette: "0", grain: "23", size: "15", roughness: "50", sharpening: "20", radius: "1", detail: "31", masking: "0"), isInPack: "0"),
    
    filter(name: "Caffeinated", tags: "atmosphere", filterFileURL: "https://kazantsev-ef.ru/ios/filters/Caffeinated/Caffeinated_filter.dng", imageBefore:  "LOCAL_Caffeinated_before", imageAfter:  "LOCAL_Caffeinated_after", filterSettings:
            imageSettings(exposure: "0.24", contrast: "6", highlights: "-100", shadows: "76", whites: "-100", blacks: "65", temperature: "11", tint: "1", vibrance: "-8", saturation: "-25", texture: "0", clarity: "0", dehaze: "0", vignette: "0", grain: "0", size: "25", roughness: "50", sharpening: "0", radius: "1", detail: "11", masking: "29"), isInPack: "0"),
    
    filter(name: "Comfy home", tags: "atmosphere", filterFileURL: "https://kazantsev-ef.ru/ios/filters/Comfy_home/Comfy_home_filter.dng", imageBefore:  "LOCAL_Comfy home_before", imageAfter:  "LOCAL_Comfy home_after", filterSettings:
            imageSettings(exposure: "0.20", contrast: "-11", highlights: "-50", shadows: "53", whites: "25", blacks: "30", temperature: "17", tint: "-13", vibrance: "19", saturation: "-4", texture: "0", clarity: "0", dehaze: "0", vignette: "0", grain: "0", size: "25", roughness: "50", sharpening: "30", radius: "1", detail: "24", masking: "0"), isInPack: "0"),
    
    filter(name: "Florida", tags: "summer", filterFileURL: "https://kazantsev-ef.ru/ios/filters/Florida/Florida_filter.dng", imageBefore:  "LOCAL_Florida_before", imageAfter:  "LOCAL_Florida_after", filterSettings:
            imageSettings(exposure: "0.30", contrast: "0", highlights: "-30", shadows: "50", whites: "-30", blacks: "74", temperature: "0", tint: "0", vibrance: "18", saturation: "-25", texture: "0", clarity: "10", dehaze: "0", vignette: "0", grain: "3", size: "25", roughness: "50", sharpening: "25", radius: "1", detail: "25", masking: "0"), isInPack: "0"),
    
    filter(name: "Hygge vibes", tags: "atmosphere", filterFileURL: "https://kazantsev-ef.ru/ios/filters/Hygge_vibes/Hygge_vibes_filter.dng", imageBefore:  "LOCAL_Hygge vibes_before", imageAfter:  "LOCAL_Hygge vibes_after", filterSettings:
            imageSettings(exposure: "0.57", contrast: "23", highlights: "-100", shadows: "87", whites: "-41", blacks: "99", temperature: "18", tint: "-59", vibrance: "-50", saturation: "-7", texture: "0", clarity: "20", dehaze: "25", vignette: "0", grain: "0", size: "25", roughness: "50", sharpening: "0", radius: "1", detail: "25", masking: "0"), isInPack: "0"),
    
    filter(name: "Misty rose", tags: "urban,color", filterFileURL: "https://kazantsev-ef.ru/ios/filters/Misty_rose/Misty_rose_filter.dng", imageBefore:  "LOCAL_Misty rose_before", imageAfter:  "LOCAL_Misty rose_after", filterSettings:
            imageSettings(exposure: "0.25", contrast: "-17", highlights: "-91", shadows: "16", whites: "-79", blacks: "35", temperature: "17", tint: "7", vibrance: "27", saturation: "-21", texture: "0", clarity: "40", dehaze: "0", vignette: "2", grain: "5", size: "25", roughness: "29", sharpening: "17", radius: "1", detail: "13", masking: "0"), isInPack: "0"),
    
    filter(name: "Orange and teal", tags: "color", filterFileURL: "https://kazantsev-ef.ru/ios/filters/Orange_and_teal/Orange_and_teal_filter.dng", imageBefore:  "LOCAL_Orange and teal_before", imageAfter:  "LOCAL_Orange and teal_after", filterSettings:
            imageSettings(exposure: "-0.95", contrast: "-26", highlights: "-71", shadows: "82", whites: "-40", blacks: "-22", temperature: "9", tint: "-22", vibrance: "0", saturation: "-21", texture: "0", clarity: "0", dehaze: "0", vignette: "0", grain: "0", size: "25", roughness: "50", sharpening: "54", radius: "1", detail: "25", masking: "0"), isInPack: "0"),
    
    filter(name: "Orange and teal 2", tags: "color", filterFileURL: "https://kazantsev-ef.ru/ios/filters/Orange_and_teal_2/Orange_and_teal_2_filter.dng", imageBefore:  "LOCAL_Orange and teal 2_before", imageAfter:  "LOCAL_Orange and teal 2_after", filterSettings:
            imageSettings(exposure: "-0.25", contrast: "-26", highlights: "-71", shadows: "83", whites: "-60", blacks: "13", temperature: "9", tint: "-22", vibrance: "0", saturation: "-21", texture: "0", clarity: "0", dehaze: "0", vignette: "0", grain: "0", size: "25", roughness: "50", sharpening: "54", radius: "1", detail: "25", masking: "0"), isInPack: "0"),
    
    filter(name: "Pinky teal", tags: "summer,color", filterFileURL: "https://kazantsev-ef.ru/ios/filters/Pinky_teal/Pinky_teal_filter.dng", imageBefore:  "LOCAL_Pinky teal_before", imageAfter:  "LOCAL_Pinky teal_after", filterSettings:
            imageSettings(exposure: "-0.25", contrast: "-26", highlights: "-71", shadows: "83", whites: "-60", blacks: "13", temperature: "9", tint: "-22", vibrance: "0", saturation: "-21", texture: "0", clarity: "0", dehaze: "0", vignette: "0", grain: "0", size: "25", roughness: "50", sharpening: "54", radius: "1", detail: "25", masking: "0"), isInPack: "0"),
    
    filter(name: "Summer rocks", tags: "summer", filterFileURL: "https://kazantsev-ef.ru/ios/filters/Summer_rocks/Summer_rocks_filter.dng", imageBefore:  "LOCAL_Summer rocks_before", imageAfter:  "LOCAL_Summer rocks_after", filterSettings:
            imageSettings(exposure: "0.45", contrast: "-26", highlights: "-47", shadows: "20", whites: "-88", blacks: "23", temperature: "36", tint: "-3", vibrance: "24", saturation: "-9", texture: "0", clarity: "-3", dehaze: "0", vignette: "0", grain: "0", size: "25", roughness: "50", sharpening: "34", radius: "1", detail: "25", masking: "0"), isInPack: "0"),
    
    filter(name: "Late summer", tags: "summer", filterFileURL: "https://kazantsev-ef.ru/ios/filters/Late_summer/Late_summer_filter.dng", imageBefore:  "LOCAL_Late summer_before", imageAfter:  "LOCAL_Late summer_after", filterSettings:
            imageSettings(exposure: "0.3", contrast: "-10", highlights: "-50", shadows: "45", whites: "-26", blacks: "10", temperature: "6", tint: "-3", vibrance: "10", saturation: "0", texture: "0", clarity: "15", dehaze: "0", vignette: "0", grain: "0", size: "25", roughness: "50", sharpening: "0", radius: "1", detail: "44", masking: "0"), isInPack: "0"),
]

let localNames = ["Barberry","Caffeinated","Comfy_home","Florida","Hygge_vibes","Misty_rose","Orange_and_teal","Orange_and_teal_2","Pinky_teal","Summer_rocks","Late_summer"]

let localPacks: [pack] = []
var serverPacks: [pack] = []

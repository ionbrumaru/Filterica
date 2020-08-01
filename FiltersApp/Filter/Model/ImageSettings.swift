//
//  ImageSettings.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 01.08.2020.
//

import Foundation
import RealmSwift
class imageSettings: Object {
    
    /// LIGHT
    
    @objc dynamic var exposure: Float = 0
    @objc dynamic var contrast: Int = 0
    @objc dynamic var highlights: Int = 0
    @objc dynamic var shadows: Int = 0
    @objc dynamic var whites: Int = 0
    @objc dynamic var blacks: Int = 0
    
    /// COLOR
    
    @objc dynamic var temperature: Int = 0
    @objc dynamic var tint: Int = 0
    @objc dynamic var vibrance: Int = 0
    @objc dynamic var saturation: Int = 0
    
    /// EFFECTS
    
    @objc dynamic var texture: Int = 0
    @objc dynamic var clarity: Int = 0
    @objc dynamic var dehaze: Int = 0
    @objc dynamic var vignette: Int = 0
    @objc dynamic var grain: Int = 0
    @objc dynamic var size: Int = 0
    @objc dynamic var roughness: Int = 0
    
    /// DETAIL
    
    @objc dynamic var sharpening: Int = 0
    @objc dynamic var radius: Int = 0
    @objc dynamic var detail: Int = 0
    @objc dynamic var masking: Int = 0
    
    
    convenience init (exposure: Float, contrast: Int, highlights: Int, shadows: Int, whites: Int, blacks: Int, temperature: Int, tint: Int,
                      vibrance: Int, saturation: Int, texture: Int, clarity: Int, dehaze: Int, vignette: Int, grain: Int, size: Int,
                      roughness: Int, sharpening: Int, radius: Int, detail: Int, masking: Int)
    {
        self.init()
        
        /// LIGHT
        
        self.exposure = exposure
        self.contrast = contrast
        self.highlights = highlights
        self.shadows = shadows
        self.whites = whites
        self.blacks = blacks
        
        /// COLOR
        
        self.temperature = temperature
        self.tint = tint
        self.vibrance = vibrance
        self.saturation = saturation
        
        /// EFFECTS
        
        self.texture = texture
        self.clarity = clarity
        self.dehaze = dehaze
        self.vignette = vignette
        self.grain = grain
        self.size = size
        self.roughness = roughness
        
        /// DETAIL
        
        self.sharpening = sharpening
        self.radius = radius
        self.detail = detail
        self.masking = masking
    }
    
}

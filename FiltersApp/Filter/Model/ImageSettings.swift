//
//  ImageSettings.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 01.08.2020.
//

import Foundation
import RealmSwift

class imageSettings: Object, Codable {
    
    /// LIGHT
    
    @objc dynamic var exposure: String!
    @objc dynamic var contrast: String!
    @objc dynamic var highlights: String!
    @objc dynamic var shadows: String!
    @objc dynamic var whites: String!
    @objc dynamic var blacks: String!
    
    /// COLOR
    
    @objc dynamic var temperature: String!
    @objc dynamic var tint: String!
    @objc dynamic var vibrance: String!
    @objc dynamic var saturation: String!
    
    /// EFFECTS
    
    @objc dynamic var texture: String!
    @objc dynamic var clarity: String!
    @objc dynamic var dehaze: String!
    @objc dynamic var vignette: String!
    @objc dynamic var grain: String!
    @objc dynamic var size: String!
    @objc dynamic var roughness: String!
    
    /// DETAIL
    
    @objc dynamic var sharpening: String!
    @objc dynamic var radius: String!
    @objc dynamic var detail: String!
    @objc dynamic var masking: String!
    
    
    convenience init (exposure: String, contrast: String, highlights: String, shadows: String, whites: String, blacks: String, temperature: String, tint: String,
                      vibrance: String, saturation: String, texture: String, clarity: String, dehaze: String, vignette: String, grain: String, size: String,
                      roughness: String, sharpening: String, radius: String, detail: String, masking: String)
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

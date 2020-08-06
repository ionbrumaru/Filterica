//
//  Extensions.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 30.07.2020.
//

import Foundation
import SwiftUI
import RealmSwift
public extension View {
    func onTouchDown(
        _ onTouchDown: @escaping () -> Void,
        onTouchUp: @escaping () -> Void) -> some View {
        self.gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onChanged({ _ in onTouchDown() })
                .onEnded({ _ in onTouchUp()})
        )
    }
}
extension View {
    public func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S : ShapeStyle {
        return overlay(RoundedRectangle(cornerRadius: cornerRadius).strokeBorder(content, lineWidth: width))
    }
}

extension Data {

    /// Data into file
    ///
    /// - Parameters:
    ///   - fileName: the Name of the file you want to write
    /// - Returns: Returns the URL where the new file is located in NSURL
    func dataToFile(fileName: String) -> NSURL? {

        // Make a constant from the data
        let data = self

        // Make the file path (with the filename) where the file will be loacated after it is created
        let filePath = getDocumentsDirectory().appendingPathComponent(fileName)

        do {
            // Write the file from data into the filepath (if there will be an error, the code jumps to the catch block below)
            try data.write(to: URL(fileURLWithPath: filePath))

            // Returns the URL where the new file is located in NSURL
            return NSURL(fileURLWithPath: filePath)

        } catch {
            // Prints the localized description of the error from the do block
            print("Error writing the file: \(error.localizedDescription)")
        }

        // Returns nil if there was an error in the do-catch -block
        return nil

    }
    
    /// Get the current directory
    ///
    /// - Returns: the Current directory in NSURL
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }

}
extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        let array = Array(self) as! [T]
        return array
    }
}

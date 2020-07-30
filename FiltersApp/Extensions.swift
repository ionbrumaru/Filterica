//
//  Extensions.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 30.07.2020.
//

import Foundation
import SwiftUI
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

//
//  ActivityIndicator.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 05.08.2020.
//

import UIKit
import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool

    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: style)
        view.color = mainColor
        return view
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

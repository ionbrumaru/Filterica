//
//  ShareScreen.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 01.08.2020.
//

import SwiftUI
import UIKit

typealias Callback = (_ activityType: UIActivity.ActivityType?,
                      _ completed: Bool, _ returnedItems: [Any]?,
                      _ error: Error?) -> Void

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct ShareSheet_Previews: PreviewProvider {
    static var previews: some View {
        ShareSheet(activityItems: ["A string" as NSString])
    }
}

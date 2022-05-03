//
//  FilterViewModel.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 03.05.2022.
//

import Foundation
import SwiftUI
import StoreKit

class FilterViewModel: ObservableObject {
    @Published var isOriginalShowing = false
    @Published var showShareSheet = false

    @Published var showImageInfo: Bool = false

    @Published var fileurl : String?
    @Published var isLoading : Bool = false

    @Published var showTutorialSheet: Bool =  false

    @Published var isShareButtonDisabled: Bool = true
    @Published var showRelated: Bool = true
    @Published var showTutorial: Bool =  false


    func adviceReview() {
        // If the count has not yet been stored, this will return 0
        var count = UserDefaults.standard.integer(forKey: "reviewCounter")
        count += 1
        UserDefaults.standard.set(count, forKey: "reviewCounter")

        print("Process completed \(count) time(s)")

        // Get the current bundle version for the app
        let infoDictionaryKey = kCFBundleVersionKey as String
        guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String
        else { fatalError("Expected to find a bundle version in the info dictionary") }


        // Has the process been completed several times and the user has not already been prompted for this version?
        if count == 4 {
            let twoSecondsFromNow = DispatchTime.now() + 4.0
            DispatchQueue.main.asyncAfter(deadline: twoSecondsFromNow) {
                SKStoreReviewController.requestReview()
            }
        }
    }

    func loadFilter(filterfileurl: String) {
        print("LOAD FILTER FUNC")
        let urlString = filterfileurl

        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data {
                // we got some data back!
                self?.fileurl = (data.dataToFile(fileName: "filter.dng")!.absoluteString)!
                self?.isShareButtonDisabled = false
                self?.isLoading = false
            }
            // if we're still here it means the request failed somehow
        }.resume()
    }
}

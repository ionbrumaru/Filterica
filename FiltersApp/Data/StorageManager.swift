//
//  DataManager.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 30.07.2020.
//

import RealmSwift
import SwiftUI

public class StorageManager {
    
    
    static func saveObject (_ filter: filter) {
        try! realmData.write() {
            realmData.add(filter)
        }
    }
    
    static func deleteObject(_ filter: filter) {
        try! realmData.write() {
            realmData.delete(filter)
        }
    }
    
    func fetchData(completion: @escaping ([[String:Any]]?, Error?) -> Void) {
        print("started fetching")
        let url = URL(string: "https://kazantsev-ef.ru/ios.php?p=all_filters")!

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                if let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String : Any]]{
                    print("recieved data from server")
                    completion(array, nil)
                }
            } catch {
                print(error)
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    func loadFiltersFromServer() {
        StorageManager().fetchData { (dict, error) in
            
            if dict != nil {
                for fltr_obj in dict! {
                    
                    if localFilters.contains(where: { ($0 ).name == fltr_obj["name"] as! String }) {
                         // found
                        // filter already exists. no need to reload it from server
                    } else {
                         // not
                        var fltr = serverFilter(name: fltr_obj["name"] as! String, filterDescription: "", tags: "", filterFileURL: fltr_obj["filterFileUrl"] as! String, imageBefore: fltr_obj["imageBefore"] as! String, imageAfter: fltr_obj["name"] as! String, filterSettings: imageSettings())
                        
                        UserData().servFilters.append(fltr)
                    }
                    
                    print(UserData().servFilters)
                    
                    
                }
            }
        }
    }
}

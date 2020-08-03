//
//  ContentView.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 30.07.2020.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var ud = UserData()
    
    var body: some View {

        FiltersList().environmentObject(ud).onAppear(){
            DispatchQueue.main.async {
                loadFiltersFromServer()
                }
            
        }
        
            /*
            .onAppear {
            
            let stringPath = Bundle.main.path(forResource: "filter", ofType: "dng")
            
            let a = filter(name: "MountainFX", filterDescription: "adds a fantastic blur to image. So gorgeus that you can use it with any type of image even if its black and white", tags: "nature,mountains,hiking", filterFileURL: "https://kazantsev-ef.ru/ios/Dragon_r_Paren_krd.dng", imageBefore: UIImage(named: "test")?.pngData(), imageAfter: UIImage(named: "test2")?.pngData())
            
            StorageManager.saveObject(a)
           
        }
 */
 
    }
    
    func fetchData(completion: @escaping ([String:[[String:Any]]]?, Error?) -> Void) {
        print("started fetching")
        let url = URL(string: "https://kazantsev-ef.ru/ios.php?p=all_filters")!

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                if let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:[[String:Any]]]{
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
        
        fetchData { (dict, error) in
            
            if dict != nil {
                for fltr_obj in dict!["filters"]! {
                    
                    if localFilters.contains(where: { ($0 ).name == (fltr_obj["name"] as! String).replacingOccurrences(of: "_", with: " ") }) {
                         // found
                        // filter already exists. no need to reload it from server
                    } else {
                         // not
                        var fltr = serverFilter(name: (fltr_obj["name"] as! String).replacingOccurrences(of: "_", with: " "), filterDescription: "", tags: "", filterFileURL: fltr_obj["filterFileUrl"] as! String, imageBefore: fltr_obj["imageBefore"] as! String, imageAfter: fltr_obj["imageAfter"] as! String, filterSettings: imageSettings(), isInPack: Int(fltr_obj["isInPack"] as! String)!)
                        
                        
                            self.ud.child.appendServerFilters(srvflt: fltr)
                    }
                    
                }
                
                for fltr_obj in dict!["packs"]! {
                    
                    if localPacks.contains(where: { ($0 ).name == (fltr_obj["name"] as! String).replacingOccurrences(of: "_", with: " ") }) {
                         // found
                        // filter already exists. no need to reload it from server
                    } else {
                         // not
                        var pck = pack(id: Int(fltr_obj["id"] as! String)!, name: (fltr_obj["name"] as! String).replacingOccurrences(of: "_", with: " "), isFree: fltr_obj["isFree"] as! Int)
                        
                        
                        self.ud.child.appendServerPacks(pck: pck)
                        
                    }
                    
                }
            }
        }
        
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

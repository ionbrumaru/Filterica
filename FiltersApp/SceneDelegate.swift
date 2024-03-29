//
//  SceneDelegate.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 30.07.2020.
//

import UIKit
import SwiftUI
import RealmSwift
import SwiftyJSON

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private var filters: Results<filter>?
    private var packs: Results<Pack>?
    private var filterstosave: [filter] = []
    private var packstosave: [Pack] = []
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().backgroundColor = .systemBackground

        let contentView = ContentView()
        let tutorial = FirstViews()
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            let realm = try! Realm()
            try! realm.write {
              realm.deleteAll()
            }

            let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")

            if hasLaunchedBefore {
                loadFiltersFromServer()
                
                let filterStorage = FilterStorage()
                window.rootViewController = UIHostingController(rootView: contentView.environmentObject(filterStorage))
            } else {
                do {
                    var realm2 = try Realm()
                    filters = realm2.objects(filter.self)
                    packs = realm2.objects(Pack.self)

                    if filters!.count == 0 {
                        for element in localFiters {
                            try! realm2.write() {
                                realm2.add(element)
                            }
                        }
                    }
                }
                catch let error as NSError {
                    print(error.localizedDescription)
                }
                
                
                loadFiltersFromServer()
                let filterStorage = FilterStorage()
                window.rootViewController = UIHostingController(rootView: tutorial.environmentObject(filterStorage))
                UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            }
            
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    
    func fetchData(completion: @escaping ([String:[[String:Any]]]?, Error?) -> Void) {
        print("started fetching")
        let url = URL(string: "https://kazantsev-ef.ru/ios.php?p=all_filters")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { self.uploadLocalToRealm(); return }
            do {
                if let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:[[String:Any]]]{
                    print("recieved data from server")
                    
                    completion(array, nil)
                }
            } catch {
                print("ERROR")
                print(error)
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    
    func uploadLocalToRealm() {
        do {
            var realm2 = try Realm()
            filters = realm2.objects(filter.self)
            packs = realm2.objects(Pack.self)

            if filters!.count == 0 {
                for element in localFiters {
                    try! realm2.write() {
                        realm2.add(element)
                    }
                }
            }
            for element in filterstosave {
                var alreadyHasFilter = false
                for el in filters?.toArray(ofType: filter.self) ?? [] {
                    if el.name == element.name { alreadyHasFilter = true; break}
                }
                if !alreadyHasFilter {
                    print("FINALLY CHECKED THAT THERE IS NO SUCH filter \(element.name). SAVING IT")
                    try! realm2.write() {
                        realm2.add(element)
                    }
                }
            }
            
            for element in packstosave {
                var alreadyHasPack = false
                for el in packs?.toArray(ofType: Pack.self) ?? [] {
                    if el.name == element.name { alreadyHasPack = true; break}
                }
                
                if !alreadyHasPack {
                    print("SAVING SERVER FILTER \(element.name)")
                    try! realm2.write() {
                        realm2.add(element)
                    }
                }
            }
            
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    func loadFiltersFromServer() {
        fetchData { (dict, error) in
            print("completion")
            if dict != nil {
                //processing filters
                for i in 0 ..< dict!["filters"]!.count {
                    var filterObject = dict!["filters"]![i]
                    filterObject["liked"] = false
                    
                    let dataFilter = try! JSONSerialization.data(withJSONObject: filterObject, options: .prettyPrinted)
                    print(filterObject)
                    if localNames.contains(filterObject["name"] as? String ?? "None") {
                        continue
                    }
                    var fltr = try! JSONDecoder().decode(filter.self, from: dataFilter)
                    fltr.name = fltr.name.replacingOccurrences(of: "_", with: " ")
                    
                    self.filterstosave.append(fltr)
                    print(fltr.name)
                }
                //processing packs
                for fltr_obj in dict!["packs"]! {
                    let pck = Pack(id: Int(fltr_obj["id"] as! String)!, name: (fltr_obj["name"] as! String).replacingOccurrences(of: "_", with: " "), isFree: fltr_obj["isFree"] as! Int)
                    self.packstosave.append(pck)
                    print(pck.name)
                }
                
                print("trying to upload new arrays to realm")
                self.uploadLocalToRealm()
            }
        }
    }
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}


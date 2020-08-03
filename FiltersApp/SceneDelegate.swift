//
//  SceneDelegate.swift
//  FiltersApp
//
//  Created by Никита Казанцев on 30.07.2020.
//

import UIKit
import SwiftUI
import RealmSwift
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var realm = try! Realm()
    private var filters: Results<filter>?
    private var filterstosave: [filter] = []
    private var packstosave: [pack] = []
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()
        let tutorial = FirstViews()
        
        

        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            if hasLaunchedBefore {
                //filters = realm.objects(filter.self)
            window.rootViewController = UIHostingController(rootView: contentView)
            } else {
                //uploadLocalToRealm()
                print("before loading")
                //filters = realm.objects(filter.self)
               loadFiltersFromServer()
                
                window.rootViewController = UIHostingController(rootView: tutorial)
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
            guard let data = data else { return }
            do {
                if let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:[[String:Any]]]{
                    print("recieved data from server")
                    
                    completion(array, nil)
                }
            } catch {
                print("!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                print(error)
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    
    func uploadLocalToRealm() {
        print(Thread.current)
        
        var realm2 = try! Realm()
        filters = realm2.objects(filter.self)
        //localFiters
        if filters!.count == 0 {
            for element in localFiters {
                print(1)
                try! realm2.write() {
                   realm2.add(element)
                }
            }
        }
        for element in filterstosave {
            print(2)
            try! realm2.write() {
               realm2.add(element)
            }
        }
        
        for element in packstosave {
            print(2)
            try! realm2.write() {
               realm2.add(element)
            }
        }
    }
    
    func saveObject (_ filter: filter) {
        try! realm.write() {
            realm.add(filter)
        }
    }
    
    
    func loadFiltersFromServer() {
        
        
        fetchData { (dict, error) in
            print("completion")
            if dict != nil {
                for fltr_obj in dict!["filters"]! {
                    print(fltr_obj)
                    
                    if self.filters?.contains(where: { ($0 ).name == (fltr_obj["name"] as! String).replacingOccurrences(of: "_", with: " ") }) ?? false || localFiters.contains(where: { ($0 ).name == (fltr_obj["name"] as! String).replacingOccurrences(of: "_", with: " ") }) {
                         // found
                        // filter already exists. no need to reload it from server
                    }
                    else {
                         // not
                    var fltr = filter(name: (fltr_obj["name"] as! String).replacingOccurrences(of: "_", with: " "), filterDescription: "", tags: fltr_obj["name"] as! String , filterFileURL: fltr_obj["filterFileUrl"] as! String, imageBefore: fltr_obj["imageBefore"] as! String, imageAfter: fltr_obj["imageAfter"] as! String, filterSettings: imageSettings(), isInPack: Int(fltr_obj["isInPack"] as! String)!)
                        
                        print("trying to append")
                    DispatchQueue.main.async {
                        self.filterstosave.append(fltr)
                    }
                    print("apppended")
                    
                }
                }
                
                for fltr_obj in dict!["packs"]! {
                    
                    if localPacks.contains(where: { ($0 ).name == (fltr_obj["name"] as! String).replacingOccurrences(of: "_", with: " ") }) {
                         // found
                        // filter already exists. no need to reload it from server
                    } else {
                         // not
                        var pck = pack(id: Int(fltr_obj["id"] as! String)!, name: (fltr_obj["name"] as! String).replacingOccurrences(of: "_", with: " "), isFree: fltr_obj["isFree"] as! Int)
                        
                        print("trying to append")
                        DispatchQueue.main.async {
                            self.packstosave.append(pck)
                        }
                        
                    }
                    
                }
                print(Thread.current)
                
                print("trying to upload local to realm")
                self.uploadLocalToRealm()
            }
        }
        
        //print("trying to upload local to realm")
        //self.uploadLocalToRealm()
        
        
        
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


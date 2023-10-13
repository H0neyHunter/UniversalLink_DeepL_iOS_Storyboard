//
//  SceneDelegate.swift
//  DeepLink_iOS_Storyboard
//
//  Created by Ümit Örs on 13.10.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    /**
     Örnek linkimiz : https://usyssoft.com/data?field1=323&field2=999  olsun.  burada field1 ve field2 verilerini almak için aşağıdaki kodlamaları kontrol edebilirsiniz. Yapmak istenilen SceneDelegate'yi baz alalım.  Uygulama kapalı iken (yani willConnectTo) NotificationCenter işe yaramıyor ve bunun için  userdefaults willconnectto 1 değerini verdim ki ViewControllerde userdefault da willconnectto degeri 1 ise normal alert sundum. 1 değil ise notificationcenter çalışacak yani uygulama açıkken linke tıklanıldığı için NotificationCenter ile işlem yapmış oldum.
     */
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        if let userActivity = connectionOptions.userActivities.first ?? session.stateRestorationActivity {
            if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
               let webpageURL = userActivity.webpageURL {
                
                if let queryItems = URLComponents(url: webpageURL, resolvingAgainstBaseURL: true)?.queryItems {
                    for queryItem in queryItems {
                        if queryItem.name == "field1" {
                            if let field1Value = queryItem.value {
                                UserDefaults.standard.set(field1Value  + "scenewillconnecto", forKey: "field1")
                            }
                        } else if queryItem.name == "field2" {
                            if let field2Value = queryItem.value {
                                UserDefaults.standard.set(field2Value + "scenewillconnecto", forKey: "field2")
                            }
                        }
                    }
                    UserDefaults.standard.set(1, forKey: "willconnectto")
                }
            }
        }
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
           let webpageURL = userActivity.webpageURL {
            
            if let queryItems = URLComponents(url: webpageURL, resolvingAgainstBaseURL: true)?.queryItems {
                for queryItem in queryItems {
                    if queryItem.name == "field1" {
                        if let field1Value = queryItem.value {
                            UserDefaults.standard.set(field1Value + "scenecontinueuser", forKey: "field1")
                        }
                    } else if queryItem.name == "field2" {
                        if let field2Value = queryItem.value {
                            UserDefaults.standard.set(field2Value + "scenecontinueuser", forKey: "field2")
                        }
                    }
                }
                NotificationCenter.default.post(Notification(name: Notification.Name("didReceiveNotification")))
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


<h1 align="center">Hi 👋, I'm Ümit ÖRS</h1>
<h3 align="center">A passionate frontend developer from Turkey</h3>

<h3 align="center">Using Universal Link iOS - Storyboard AppDelegate</h3>


Add Associatted Domains from Project/targets/ +Capability and add Links into it
Ex: applinks:example.com/data  





Change the Json layout below to redirect to the Apple Store and add it to your site. 
Recommended: https://www.example.com/.well-known/apple-app-site-association or https://example.com/apple-app-site-association

(There is no apple-app-site-association file suffix - Example: It is not in the form apple-app-site-association.json. Just app-site-association this way)

appID : Team_ID.Bundle_ID (4YV748ZZZZ.com.usyssoft.DeepLink-iOS-Storyboard)

```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "4YV748ZZZZ.com.usyssoft.DeepLink-iOS-Storyboard",
        "paths": [
          "/data*"
        ]
      }
    ]
  }
}

```

Let our example link be: https://usyssoft.com/data?field1=323&field2=999. here you can check below encodings to get field1 and field2 data.

AppDelegate : continue userActivity (//Processes while the application is open and works on iOS 13 and earlier.) 
  && open url (//If the application is closed, it is processed and works on iOS 13 and earlier. But it works in all versions when the application is not installed.)

```swift

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
           let webpageURL = userActivity.webpageURL {
            
            if let queryItems = URLComponents(url: webpageURL, resolvingAgainstBaseURL: true)?.queryItems {
                for queryItem in queryItems {
                    if queryItem.name == "field1" {
                        if let field1Value = queryItem.value {
                            UserDefaults.standard.set(field1Value + "appdelegatecontinueuser", forKey: "field1")
                        }
                    } else if queryItem.name == "field2" {
                        if let field2Value = queryItem.value {
                            UserDefaults.standard.set(field2Value + "appdelegatecontinueuser", forKey: "field2")
                        }
                    }
                }
                NotificationCenter.default.post(Notification(name: Notification.Name("didReceiveNotification")))
            }
            return true
        }
        return false
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems {
            for queryItem in queryItems {
                if queryItem.name == "field1" {
                    if let field1Value = queryItem.value {
                        UserDefaults.standard.set(field1Value + "appdelegateopenurl", forKey: "field1")
                    }
                } else if queryItem.name == "field2" {
                    if let field2Value = queryItem.value {
                        UserDefaults.standard.set(field2Value + "appdelegateopenurl", forKey: "field2")
                    }
                }
            }
            UserDefaults.standard.set(1, forKey: "willconnectto")
        }
        return true
    }
```



SceneDelegate : willConnectTo session (//Processing while the application is closed. ios 14 and later) 
  && continue userActivity (//Processing while the application is open. ios 14 and later)

```swift
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
```

I am giving the coding of my userdefaults and notificationCenter explanation above with ViewController.
What I want to do here is, as I mentioned above, notificationcenter did not work in willconnectto, so I checked it with userdefaults and applied the algorithm below. If it was 1, I displayed it with normal alert. If it was not 1, I ran it if it came from notificationcenter.

```swift
override func viewDidAppear(_ animated: Bool) {
        if let willconnecttocontrol = UserDefaults.standard.object(forKey: "willconnectto") as? Int {
            if willconnecttocontrol == 1 {
                LinkFieldGetFunctions()
                UserDefaults.standard.removeObject(forKey: "willconnectto")
            }else {
                NotificationCenter.default.addObserver(self, selector: #selector(NotifyCenterControlFunc), name: NSNotification.Name("didReceiveNotification"), object: nil)
            }
        }else {
            NotificationCenter.default.addObserver(self, selector: #selector(NotifyCenterControlFunc), name: NSNotification.Name("didReceiveNotification"), object: nil)
        }
        
        
    }
    
    @objc func NotifyCenterControlFunc(){
        LinkFieldGetFunctions()
    }
    
    func LinkFieldGetFunctions(){
        var string = ""
        if let field1 = UserDefaults.standard.object(forKey: "field1") as? String {
            string += "field1:" + field1 + "\n"
        }
        if let field2 = UserDefaults.standard.object(forKey: "field2") as? String {
            string += "field2:" + field2
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            let alert = UIAlertController(title: "Field", message: string, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default))
            self.present(alert, animated: true)
        })
    }
```




- 📫 How to reach me **usysstr@gmail.com**

<h3 align="left">Connect with me:</h3>
<p align="left">
<a href="https://twitter.com/umithoney" target="blank"><img align="center" src="https://raw.githubusercontent.com/rahuldkjain/github-profile-readme-generator/master/src/images/icons/Social/twitter.svg" alt="umithoney" height="30" width="40" /></a>
<a href="https://linkedin.com/in/ümit-ö-486ab1224" target="blank"><img align="center" src="https://raw.githubusercontent.com/rahuldkjain/github-profile-readme-generator/master/src/images/icons/Social/linked-in-alt.svg" alt="ümit-ö-486ab1224" height="30" width="40" /></a>
</p>

<h3 align="left">Languages and Tools:</h3>
<p align="left"> <a href="https://developer.android.com" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/android/android-original-wordmark.svg" alt="android" width="40" height="40"/> </a> <a href="https://www.arduino.cc/" target="_blank" rel="noreferrer"> <img src="https://cdn.worldvectorlogo.com/logos/arduino-1.svg" alt="arduino" width="40" height="40"/> </a> <a href="https://dart.dev" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/dartlang/dartlang-icon.svg" alt="dart" width="40" height="40"/> </a> <a href="https://www.figma.com/" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/figma/figma-icon.svg" alt="figma" width="40" height="40"/> </a> <a href="https://firebase.google.com/" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/firebase/firebase-icon.svg" alt="firebase" width="40" height="40"/> </a> <a href="https://flutter.dev" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/flutterio/flutterio-icon.svg" alt="flutter" width="40" height="40"/> </a> <a href="https://git-scm.com/" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/git-scm/git-scm-icon.svg" alt="git" width="40" height="40"/> </a> <a href="https://kotlinlang.org" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/kotlinlang/kotlinlang-icon.svg" alt="kotlin" width="40" height="40"/> </a> <a href="https://www.linux.org/" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/linux/linux-original.svg" alt="linux" width="40" height="40"/> </a> <a href="https://www.mysql.com/" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/mysql/mysql-original-wordmark.svg" alt="mysql" width="40" height="40"/> </a> <a href="https://www.php.net" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/php/php-original.svg" alt="php" width="40" height="40"/> </a> <a href="https://postman.com" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/getpostman/getpostman-icon.svg" alt="postman" width="40" height="40"/> </a> <a href="https://www.sqlite.org/" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/sqlite/sqlite-icon.svg" alt="sqlite" width="40" height="40"/> </a> <a href="https://developer.apple.com/swift/" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/swift/swift-original.svg" alt="swift" width="40" height="40"/> </a> </p>

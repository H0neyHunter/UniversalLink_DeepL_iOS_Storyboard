//
//  ViewController.swift
//  DeepLink_iOS_Storyboard
//
//  Created by Ümit Örs on 13.10.2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var field1Label: UILabel!
    
    @IBOutlet weak var field2Label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
    }
    
    /**
     Örnek linkimiz : https://usyssoft.com/data?field1=323&field2=999  olsun.  burada field1 ve field2 verilerini almak için aşağıdaki kodlamaları kontrol edebilirsiniz. Yapmak istenilen SceneDelegate'yi baz alalım.  Uygulama kapalı iken (yani willConnectTo) NotificationCenter işe yaramıyor ve bunun için  userdefaults willconnectto 1 değerini verdim ki ViewControllerde userdefault da willconnectto degeri 1 ise normal alert sundum. 1 değil ise notificationcenter çalışacak yani uygulama açıkken linke tıklanıldığı için NotificationCenter ile işlem yapmış oldum.
     */
    
    /**
     Burada yapmak istediğim yukarıda da bahsettiğim gibi willconnectto da notificationcenter çalışmadı ve bu yüzden onu userdefaults ile kontrol ettim ve aşağıdaki algoritmayı uyguladım. 1 ise normal alert ile gösterim yaptım 1 değil ise notificationcenter dan geldiyse onu çalıştırmış oldum.
     */
    override func viewDidAppear(_ animated: Bool) {
        if let willconnecttocontrol = UserDefaults.standard.object(forKey: "willconnectto") as? Int {
            if willconnecttocontrol == 1 {
                LinkFieldGetFunctions()
                UserDefaults.standard.set(0, forKey: "willconnectto")
            }else {
                NotificationCenter.default.addObserver(self, selector: #selector(NotifyCenterControlFunc), name: NSNotification.Name("didReceiveNotification"), object: nil)
                UserDefaults.standard.set(0, forKey: "willconnectto")
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
            field1Label.text = "Field1: " + field1
        }
        if let field2 = UserDefaults.standard.object(forKey: "field2") as? String {
            string += "field2:" + field2
            field2Label.text = "Field2: " + field2
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            let alert = UIAlertController(title: "Field", message: string, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default))
            self.present(alert, animated: true)
            
            
        })
    }

}


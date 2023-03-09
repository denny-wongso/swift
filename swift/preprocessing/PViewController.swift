//
//  PViewController.swift
//  swift
//
//  Created by Denny Wongso on 10/3/23.
//


import Foundation
import UIKit

public class PViewController: UIViewController {
    
    @IBOutlet weak var dataOne: UILabel!
    @IBOutlet weak var dataTwo: UILabel!
    
    var server: CloudData? = nil
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        #if PRODUCTION
        server = ProdClass()
        #endif
        #if DEBUG
        server = DevClass()
        #endif
        dataOne.text = server?.getName() ?? "no data"
        dataTwo.text = server?.getURL() ?? "no data"
        
    }
    
    
}


protocol CloudData {
    func getName() -> String
    func getURL() -> String
}

#if PRODUCTION
class ProdClass: CloudData {
    func getName() -> String {
        return "prod"
    }
    
    func getURL() -> String {
        return "google.com/prod"
    }
}
#endif

#if DEBUG
class DevClass: CloudData {
    func getName() -> String {
        return "dev"
    }
    
    func getURL() -> String {
        return "google.com/dev"
    }
    
    
}
#endif

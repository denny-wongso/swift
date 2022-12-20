//
//  GCDViewController.swift
//  swift
//
//  Created by Denny Wongso on 20/12/22.
//

import Foundation
import UIKit

class GCDViewController: UIViewController {
    @IBOutlet weak var ImageView1: UIImageView!
    @IBOutlet weak var ImageView2: UIImageView!
    
    private let concurrentPhotoQueue =
    DispatchQueue(
        label: "com.denny.swift.grand-central-dispatch.concurrentQueue",
        attributes: .concurrent)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let defaultimage = UIImage(named: "default_dog.png") else {
            return
        }
        ImageView1.image = defaultimage
        ImageView2.image = defaultimage
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnFetch1(_ sender: UIButton) {
        guard let image = UIImage.gif(name: "spinnergif") else {
            return
        }
        ImageView1.image = image
        let delay: Double = Double(Int.random(in: 2...10))
        // 1
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else {
                return
            }
            guard let image2 = UIImage(named: "dog1.png") else {
                return
            }
            
            // 2
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                // 3
                self?.ImageView1.image = image2
            }
        }
    }
    
    @IBAction func btnFecth2(_ sender: UIButton) {
        guard let image = UIImage.gif(name: "spinnergif") else {
            return
        }
        ImageView2.image = image
        let delay: Double = Double(Int.random(in: 2...10))
        // 1
        DispatchQueue.global(qos: .userInitiated).async { [delay, weak self] in
            guard let self = self else {
                return
            }
            guard let image2 = UIImage(named: "dog2.png") else {
                return
            }
            
            // 2
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                // 3
                self?.ImageView2.image = image2
            }
        }
    }
}

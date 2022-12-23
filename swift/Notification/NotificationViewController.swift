//
//  NotificationViewController.swift
//  swift
//
//  Created by Denny Wongso on 23/12/22.
//

import UIKit

class NotificationViewController: UIViewController {
    
    @IBOutlet weak var textFieldTitle: UITextField!
    @IBOutlet weak var textFieldContent: UITextField!
    @IBOutlet weak var switchRepeat: UISwitch!
    @IBOutlet weak var textFieldInterval: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestAuthorization(completion: {(success) in
            
        })
        //fetchNotificationSettings()
        
    }
    
    @IBAction func submitOnClick(_ sender: Any) {
        let title = textFieldTitle.text ?? "default title"
        let body = textFieldContent.text ?? "default body"
        let interval = textFieldInterval.text ?? "0.0"
        scheduleNotification(title: title, body: body, doRepeat: switchRepeat.isOn, timeInterval: Double(interval) ?? 60.0)
        showToast(message : "notification added", font: UIFont.systemFont(ofSize: 12))
        
    }
    
    func requestAuthorization(completion: @escaping  (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _  in
            // TODO: Fetch notification settings
            completion(granted)
        }
    }
    
    //    func fetchNotificationSettings() {
    //      // 1
    //      UNUserNotificationCenter.current().getNotificationSettings { settings in
    //        // 2
    //        DispatchQueue.main.async {
    //
    //        }
    //      }
    //    }
    
    
    func scheduleNotification(title: String, body: String, doRepeat: Bool, timeInterval: TimeInterval) {
        // 2
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        // 3
        var trigger: UNNotificationTrigger?
        
        trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: timeInterval,
            repeats: doRepeat)
        
        // 4
        if let trigger = trigger {
            let request = UNNotificationRequest(
                identifier: UUID().uuidString,
                content: content,
                trigger: trigger)
            // 5
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(error)
                }
            }
        }
    }
    
    func showToast(message : String, font: UIFont) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

}

//
//  URLSessionViewController.swift
//  swift
//
//  Created by Denny Wongso on 21/12/22.
//

import Foundation
import UIKit

class URLSessionViewController: UIViewController {
    
    @IBOutlet weak var labelChartName: UILabel!
    @IBOutlet weak var labelUsdCode: UILabel!
    @IBOutlet weak var labelUsdPrice: UILabel!
    @IBOutlet weak var labelGBPCode: UILabel!
    @IBOutlet weak var labelGBPPrice: UILabel!
    @IBOutlet weak var labelEURCode: UILabel!
    @IBOutlet weak var labelEURPrice: UILabel!
    @IBOutlet weak var labelCounter: UILabel!

    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        labelChartName.layer.cornerRadius = 6
        labelChartName.layer.masksToBounds = true
        self.updateUI()
        self.counter(counter: 60)
        Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self](Timer) in
            self?.updateUI()
            self?.counter(counter: 60)
        }
    }
    
    private func counter(counter: Int) {
        timer.invalidate()
        var c = counter
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] (Timer) in
            c = c - 1
            self?.labelCounter.text = String(c)
            if c < 6 {
                self?.labelCounter.textColor = .red
            } else {
                self?.labelCounter.textColor = .black
            }
        }
    }
    
    private func updateUI() {
        getCurrentPrices(completion: {[weak self](currentPrice, status) in
            if status == "success" {
                guard let price = currentPrice else {
                    return
                }
                DispatchQueue.main.async {
                    self?.labelChartName.text = price.chartName
                    for each in price.bpi {
                        if each.code == "USD" {
                            self?.labelUsdCode.text = each.code
                            self?.changeColor(label: self?.labelUsdPrice, price: each.rate_float)
                            self?.labelUsdPrice.text = String(each.rate_float)
                        } else if each.code == "GBP" {
                            self?.labelGBPCode.text = each.code
                            self?.changeColor(label: self?.labelGBPPrice, price: each.rate_float)
                            self?.labelGBPPrice.text = String(each.rate_float)
                        } else if each.code == "EUR" {
                            self?.labelEURCode.text = each.code
                            self?.changeColor(label: self?.labelEURPrice, price: each.rate_float)
                            self?.labelEURPrice.text = String(each.rate_float)
                        }
                    }
                }
                
            }
        })
    }
    
    private func changeColor(label: UILabel?, price: Double) {
        guard let label = label, let text = label.text, let oldPrice = Double(text) else {
            return
        }
        if oldPrice > price {
            label.textColor = .red
        } else {
            label.textColor = .green
        }
    }
    
    private func getCurrentPrices(completion: ((CurrentPrice?, String) -> Void)?) {
        dataTask?.cancel()
        
        if let urlComponents = URLComponents(string: "https://api.coindesk.com/v1/bpi/currentprice.json") {
              guard let url = urlComponents.url else {
                return
              }

            dataTask = defaultSession.dataTask(with: url) { [completion, weak self] data, response, error in
            defer {
              self?.dataTask = nil
            }
            // 5
            if let error = error {
              completion?(nil,"DataTask error: " + error.localizedDescription + "\n")
            } else if
              let data = data,
              let response = response as? HTTPURLResponse,
              response.statusCode == 200 {
              self?.updateCurrentPrice(data, completion)
            }
          }
          // 7
          dataTask?.resume()
        }
    }
    
    func updateCurrentPrice(_ data: Data,_ completion: ((CurrentPrice?, String) -> Void)?) {
        var response: [String: Any]?
        do {
          response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch let parseError as NSError {
            completion?(nil, "JSONSerialization error: \(parseError.localizedDescription)\n")
        }
        
        guard let time = response?["time"] as? [String: Any] else {
            completion?(nil, "Dictionary does not contain results key\n")
            return
        }
        let updated = time["updated"] as? String ?? ""
        let updatedISO = time["updatedISO"] as? String ?? ""
        let updateduk = time["updateduk"] as? String ?? ""
        let disclaimer = response?["disclaimer"] as? String ?? ""
        let chartName = response?["chartName"] as? String ?? ""
        
        let currentPrice = CurrentPrice(time_updated: updated, time_updatedISO: updatedISO, time_updateduk: updateduk, disclaimer: disclaimer, chartName: chartName, bpi: [])
        guard let bpi = response?["bpi"] as? [String: Any] else {
            completion?(nil, "Dictionary does not contain results key\n")
            return
        }
        
        guard let usd = bpi["USD"] as? [String: Any],
              let gbp = bpi["GBP"] as? [String: Any],
              let eur = bpi["EUR"] as? [String: Any] else {
            completion?(nil, "Dictionary does not contain results key\n")
            return
        }
        var data: [[String: Any]] = []
        data.append(usd)
        data.append(gbp)
        data.append(eur)
        
        for each in data {
            if let code = each["code"] as? String,
               let symbol = each["symbol"] as? String,
               let rate = each["rate"] as? String,
               let description = each["description"] as? String,
               let rate_float = each["rate_float"] as? Double
            {
                let bpi = Bpi(code: code, symbol: symbol, rate: rate, description: description, rate_float: rate_float)
                currentPrice.bpi.append(bpi)
            }
        }
        
        completion?(currentPrice, "success")
    }
}

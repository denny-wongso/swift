//
//  CurrentPrice.swift
//  swift
//
//  Created by Denny Wongso on 21/12/22.
//

import Foundation

class CurrentPrice {
    var time_updated: String
    var time_updatedISO: String
    var time_updateduk: String
    var disclaimer: String
    var chartName: String
    var bpi: [Bpi]
    
    init(time_updated: String, time_updatedISO: String, time_updateduk: String, disclaimer: String, chartName: String, bpi: [Bpi]) {
        self.time_updated = time_updated
        self.time_updatedISO = time_updatedISO
        self.time_updateduk = time_updateduk
        self.disclaimer = disclaimer
        self.chartName = chartName
        self.bpi = bpi
    }
}


class Bpi {
    var code: String
    var symbol: String
    var rate: String
    var description: String
    var rate_float: Double
    init(code: String, symbol: String, rate: String, description: String, rate_float: Double) {
        self.code = code
        self.symbol = symbol
        self.rate = rate
        self.description = description
        self.rate_float = rate_float
    }
}

//
//  CoinModel.swift
//  ByteCoine
//
//  Created by ahmed khaled on 06/08/2023.
//

import Foundation


struct CoinModel {
    let currencyName: String
    let rate: Double
    
    var rateString: String {
        return String(format: "%.4f", rate)
    }
}

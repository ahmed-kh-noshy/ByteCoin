//
//  CoinManager.swift
//  ByteCoine
//
//  Created by ahmed khaled on 06/08/2023.
//

import Foundation


protocol CoinManagerDelegate{
    func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "411BCA22-D448-4384-A61E-B1A6E7476753"
    let currencyArray = ["Select Currency","AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        print(urlString)
        performRequest(with: urlString)
    }
    func performRequest(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData){
                        delegate?.didUpdateCoin(self, coin: bitcoinPrice)
                    }
                    
                }
            }
            task.resume()
        }
    }
    func parseJSON(_ data: Data) -> CoinModel?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            let name = decodedData.asset_id_quote
             let currency = CoinModel(currencyName: name, rate: lastPrice)
            return currency
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}


//
//  ViewController.swift
//  BitcoinConverter
//
//  Created by Priit Pärl on 08/02/2018.
//  Copyright © 2018 Priit Pärl. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    let currencyArray: [String] = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let baseURL: String = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    var finalURL: String = ""
    
    // IBOutlets
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.delegate = self
        currencyPicker.delegate = self
        
        let initialCurrencyURL = generateCurrencyURL(currency: currencyArray[0])
        getCurrencyData(url: initialCurrencyURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: UIPickerView delegate methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        finalURL = generateCurrencyURL(currency: currencyArray[row])
        getCurrencyData(url: finalURL)
    }
    
    //MARK: - Networking
    
    func getCurrencyData(url: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                
                if response.result.isSuccess {
                    let currencyJSON: JSON = JSON(response.result.value!)
                    
                    self.updatePriceData(json: currencyJSON)
                    
                } else {
                    self.priceLabel.text = "Connection issues"
                }
        }
    }
    
    //MARK: UIUpdates
    
    func updatePriceData(json: JSON) {
        
        if let tempPriceValue: Double = json["open"]["hour"].double {
            
            self.priceLabel.text = String(tempPriceValue)
            
        } else {
            self.priceLabel.text = "Price unavailable"
        }
    }
    
    //MARK: Common
    
    func generateCurrencyURL(currency: String) -> String {
        return baseURL + currency
        
    }

}


// Copyright author 2020
// Created by __sh0l1n@
//

import Foundation


protocol CalculatorModelRxProtocol {
    func setNumber(n: Double, maxCharacters: Int)
    func compute(symbol: String, maxCharacters: Int)
    func getNumber() -> Double
}
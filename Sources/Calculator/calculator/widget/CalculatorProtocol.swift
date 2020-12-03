// Copyright author 2020
// Created by __sh0l1n@
//


protocol CalculatorProtocol {
    var view: CalculatorViewRx? { get }
    func setNumber(n: Double)
    func getNumber() -> Double
}
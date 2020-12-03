// Copyright author 2020
// Created by __sh0l1n@
//


class Calculator {
    private let controller = CalculatorControllerRx()

    var view: CalculatorViewRx? { 
        return controller.view as? CalculatorViewRx
    }
}

extension Calculator: CalculatorProtocol {
    func setNumber(n: Double) {
        controller.setNumber(n: n)
    }
    
    func getNumber() -> Double {
        controller.getNumber()
    }
}
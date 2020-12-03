// Copyright author 2020
// Created by __sh0l1n@
//


class CalculatorControllerRx {
    init() {
        view = CalculatorViewRx(controller: self)
        model = CalculatorModelRx(view: view)
    }

    var model: CalculatorModelRxProtocol?
    var view: CalculatorViewRxProtocol?
}

extension CalculatorControllerRx {
    func setNumber(n: Double) {
        model?.setNumber(n: n, maxCharacters: 45)
    }

    func getNumber() -> Double {
        return model?.getNumber() ?? 0
    }
}

extension CalculatorControllerRx: CalculatorControllerRxProtocol {
    func didTouchUpInside(symbol: String, maxCharacters: Int) {
        model?.compute(symbol: symbol, maxCharacters: maxCharacters)
    }
}
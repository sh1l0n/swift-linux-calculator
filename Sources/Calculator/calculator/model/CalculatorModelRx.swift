
// Copyright author 2020
// Created by __sh0l1n@
//


enum SymbolTypes {
    case clear
    case sign
    case perc
    case mul
    case div
    case sum
    case sub
    case equals
    case dot
    case number
    case remove
}

class CalculatorModelRx {
    init(view: CalculatorViewRxProtocol?) {
        self.view = view
    }

    private var number: String = "0"
    private var operationStack: [String] = []
    private var history: String = ""

    //TODO: weak reference, check CalculatorViewRx controller property
    private var view: CalculatorViewRxProtocol?

    let dictKeys: [String: SymbolTypes] = [
        "C": .clear,
        "+/-": .sign,
        "%": .perc,
        "/": .div,
        "7": .number, 
        "8": .number,
        "9": .number,
        "x": .mul,
        "4": .number,
        "5": .number,
        "6": .number,
        "-": .sub,
        "1": .number,
        "2": .number,
        "3": .number,
        "+": .sum,
        "0": .number,
        ".": .dot,
        "=": .equals,
        "<": .remove
    ]
}

// Common functions
private extension CalculatorModelRx {
    func getDisabledSymbols(maxCharacters: Int) -> [String] {
        var symbols: [String] = []
        if number.doubleValue == 0.0 {
            symbols +=  number == "0" ? ["0"] : []
            symbols += ["+", "-", "x", "<", "/", "%", "+/-"]
            if operationStack.isEmpty {
                symbols += ["="]
            }
            if number == "0" {
                symbols += ["C"]
            }
        }
        if number.contains(".") || number.contains("e") || number.count >= maxCharacters - 2 { // #Only e+-
            symbols += ["."]
        }

        if number.count >= maxCharacters - 1 {
             symbols += ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "+/-"]
        }
        return symbols
    }

    func removeLast(chain: String) -> String {
        var result = chain
        if result.count>0 {
            result.removeLast()
            if let last = result.last, last == "." {
                result.removeLast()
            }
        } else {
            result = "0"
        }
        return result.isEmpty ? "0" : result
    }

    func compute(operationStack: [String]) -> String {
        guard operationStack.count>=2 else {
            return number
        }
        var sum: Double = 0
        var index: Int = 0
        var doubleSum: Bool = false

        while index < operationStack.count {
            let item = operationStack[index]

            if let number = Double(item) {
                sum += number
                index += 1
                if !doubleSum {
                    doubleSum = item.contains(".")
                }
            }
            else if let key = dictKeys[item] {
                
                if index + 1 < operationStack.count - 1 {
                    break
                }
                let nextNumber = operationStack[index + 1].doubleValue
               
                switch key {
                    case .div: sum /= nextNumber
                    case .sum:  sum += nextNumber
                    case .sub: sum -= nextNumber
                    case .mul: sum *= nextNumber
                    default: break
                }
                if !doubleSum {
                    doubleSum = operationStack[index + 1].contains(".")
                }
                index += 2
            }
        }

        let sumStringValue = sum.stringValue.split(separator: ".")
        if sumStringValue.count==2 && Int(sumStringValue[1])==0 {
            return sum.intValue.stringValue
        }
    
        return sum.stringValue
    }
}

extension CalculatorModelRx: CalculatorModelRxProtocol {
    func setNumber(n: Double, maxCharacters: Int) {
        number = n.isInt ? n.intValue.stringValue : n.stringValue
        view?.update(text: number, disabledKeys: getDisabledSymbols(maxCharacters: maxCharacters))
    }

    func compute(symbol: String, maxCharacters: Int) {
        guard let key = dictKeys[symbol] else { return }

        switch key {
            case .clear: 
                number = "0"
                operationStack = []
                history += "\n"
            case .sign: number = (number.doubleValue*100.0).stringValue //number = (-1*number.doubleValue).stringValue
            case .perc: number = (number.doubleValue/100.0).stringValue
            case .div, .sum, .sub, .mul:
                operationStack.append(number)
                operationStack.append(symbol)
                history += number + ";" + symbol + ";"
                number = "0"
            break
            case .equals: 
                operationStack += [number]
                number = compute(operationStack: operationStack)
                operationStack = []
                history += "=;" + number + ";\n"
            break
            case .remove: 
                if number.contains("e") {
                    let eSplited = number.split(separator: "e")
                    let newNumber = removeLast(chain: String(eSplited[0]))
                    number = newNumber == "0" ? "0" : newNumber + "e" + eSplited[1]
                } else {
                    number = removeLast(chain: number)                
                }
            case .dot: number += (number.contains(symbol) || number.contains("e"))  ? "" : symbol
            case .number: 
                if number.contains("e") {
                    let eSplited = number.split(separator: "e")
                    number = eSplited[0] + (eSplited[0].count==1 ? "." : "") + symbol + "e" + eSplited[1]
                } else {
                    number = number == "0" ? symbol : (number + symbol) 
                }
                // let n = number.doubleValue
                // number = n.isInt ? n.intValue.stringValue : n.stringValue
        }
        view?.update(text: number, disabledKeys: getDisabledSymbols(maxCharacters: maxCharacters))
    }

    func getNumber() -> Double {
        return number.doubleValue
    }
}
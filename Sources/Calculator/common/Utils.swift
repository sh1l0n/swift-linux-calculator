// Copyright author 2020
// Created by __sh0l1n@
//

struct Offset {
    let x: Int
    let y: Int
}

struct Size {
    let width: Int
    let height: Int
}

extension Int {
    var stringValue: String {
        get {
            return String(self)
        }
    }

    var doubleValue: Double {
        get {
            return Double(self)
        }
    }
}

extension String {
    var intValue: Int {
        get {
            return Int(self) ?? 0
        }
    }

    var doubleValue: Double {
        get {
            return Double(self) ?? 0.0
        }
    }
}

extension Double {
    var stringValue: String {
        get {
            return String(self)
        }
    }

    var intValue: Int {
        get {
            return Int(self)
        }
    }

    var isInt: Bool {
        return self == self.intValue.doubleValue
    }
}
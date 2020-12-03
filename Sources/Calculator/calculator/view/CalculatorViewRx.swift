// Copyright author 2020
// Created by __sh0l1n@
//

import GLibObject
import Gtk
import Foundation


class CalculatorViewRx: Box {
    init(controller: CalculatorControllerRxProtocol?) {
        super.init(orientation: .vertical, spacing: 0)
        self.controller = controller
        draw()
    }

    //TODO: Cannot use weak because objc runtime libraries are not working well on linux
    private var controller: CalculatorControllerRxProtocol?
    private let itemSize: Int = 30
    private let displayMaxCharacters: Int = 45
    private let gridSpacing: Int = 2

    var displayLastClassName: String = ""
    var display: LabelRef?
    var grid: GridRef?

    var defaultOrderRows: Int {
        return defaultOrder.count
    }

    var defaultOrderColumns: Int {
        return defaultOrder[0].count
    }

    var cssFileName: String {
        return "calc-style"
    }

    var defaultOrder: [[String]] {
        return [
                ["+/-", "%", "/", "<"],
                ["7", "8", "9", "x"],
                ["4", "5", "6", "-"],
                ["1", "2", "3", "+"],
                ["C", "0", ".", "="],
            ]
    }

    private func clean() {
        if let grid = grid {
            remove(widget: grid)
        }
    }

    private func draw() {
        buildDisplay()
        buildGrid()
    }
}

// Drawing functions...
extension CalculatorViewRx {

    func buildDisplay()  {
        let box = BoxRef(orientation: .horizontal, spacing: 0)
        box.styleContextRef.addClass(className: "calc-display-area")
        
        display = LabelRef(str: "0")
        display?.set(singleLineMode: true)
        display?.setLine(wrap: true)
        display?.setJustify(jtype: .right) 
        display?.styleContextRef.addClass(className: "calc-display-label-24")
        
        if let display = display {
            box.add(widget: display)
            box.setChildPacking(child: display, expand: false, fill: false, padding: 0, packType: .end)  
        }
        add(widget: box)
    }

    func buildGrid() {        
        grid = GridRef()
        var lastBoxAdded: ButtonRef?

        grid?.styleContextRef.addClass(className: "calc-grid")
        grid?.setRow(homogeneous: true)
        grid?.setColumn(homogeneous: true)
        grid?.setRow(spacing: gridSpacing)
        grid?.setColumn(spacing: gridSpacing)
        
        for rowId in 0..<defaultOrder.count {
            let row = defaultOrder[rowId]
            lastBoxAdded = nil
            for column in 0..<row.count {
                let value = row[column]
                let button = ButtonRef(label: value) 
                let onclick: SignalHandler = { [weak self, value] in
                    guard let this = self else {
                        return
                    } 
                    this.controller?.didTouchUpInside(symbol: value, maxCharacters: this.displayMaxCharacters)
                }
                button.connect(signal: .clicked, to: onclick)

                if column == 3 {
                    button.styleContextRef.addClass(className: "calc-button-ope-orange")
                } else if rowId == 0 {
                    button.styleContextRef.addClass(className: "calc-button-ope-gray")
                } else {
                    button.styleContextRef.addClass(className: "calc-button-number")
                }

                if let lastBoxAdded = lastBoxAdded {
                    grid?.attachNextTo(child: button, sibling: lastBoxAdded, side: .right, width: itemSize, height: itemSize)
                }
                else {
                    grid?.attach(child: button, left: 0, top: rowId*itemSize, width: itemSize, height: itemSize)
                }
                lastBoxAdded = button
            }
        }
        if let grid = grid {
            add(widget: grid)
        }
    }
}

extension CalculatorViewRx: CalculatorViewRxProtocol {
    func update(text: String, disabledKeys: [String]) {
        display?.text = text 
        let className = text.count < 15 ? 
                "calc-display-label-24" 
                : text.count<28 ? 
                    "calc-display-label-12"
                    : "calc-display-label-8"
            
        if !displayLastClassName.isEmpty {
            display?.styleContextRef.removeClass(className: displayLastClassName)
        }
        display?.styleContextRef.addClass(className: className)
        displayLastClassName = className
        
        for rowId in 0..<defaultOrder.count {
            let row = defaultOrder[rowId]
            for column in 0..<row.count {
                if let child = grid?.getChildAt(left: column*itemSize, top: rowId*itemSize), 
                    let button = try? ButtonRef(raw: child.ptr) {
                    if let label = button.label {
                        button.set(sensitive: !disabledKeys.contains(label))
                    }
                }
            }
        }
    }
}
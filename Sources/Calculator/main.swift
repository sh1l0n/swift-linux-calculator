// Copyright author 2020
// Created by __sh0l1n@
//

import Foundation
import Gdk
import Gtk


let status = Application.run(startupHandler: nil) { app in
    let window = ApplicationWindowRef(application: app)
    window.title = "Calculator"
    window.set(resizable: false)

    let controller = Calculator()
    controller.setNumber(n: 0.0)
    if let view = controller.view {
        readCssFile(forResource: view.cssFileName)
        window.add(widget: view)    
    }

    window.showAll()
}

guard let status = status else {
    fatalError("Could not create Application")
}
guard status == 0 else {
    fatalError("Application exited with status \(status)")
}

func readCssFile(forResource: String) {
    var css = ""
    if let fileURL = Bundle.main.url(forResource: forResource, withExtension: "css") { //subdirectory: 
        if let fileContents = try? String(contentsOf: fileURL) {
            css = fileContents
            if let screen = ScreenRef.getDefault(), let css = try? CSSProvider(from: css) {
                screen.add(provider: css, priority: STYLE_PROVIDER_PRIORITY_APPLICATION)
            }
        }
    }
}

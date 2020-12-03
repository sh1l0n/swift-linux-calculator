// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Calculator",
    dependencies: [
        .package(name: "Gtk", url: "https://github.com/rhx/SwiftGtk.git", .branch("master")),
    ],
    targets: [
        .target(name: "Calculator", dependencies: ["Gtk"]),
    ]
)

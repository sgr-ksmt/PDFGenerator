// swift-tools-version:5.1

import PackageDescription

let package = Package(
        name: "PDFGenerator",
        platforms: [
            .iOS(.v10)
        ],
        products: [
            .library(name: "PDFGenerator", targets: ["PDFGenerator"])
        ],
        targets: [
            .target(name: "PDFGenerator", path: "PDFGenerator")
        ],
        swiftLanguageVersions: [.v5])

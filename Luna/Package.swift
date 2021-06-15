// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Luna",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "Model", targets: ["Model"]),
        .library(name: "ViewModel", targets: ["ViewModel"]),
        .library(name: "View", targets: ["View"]),
        .library(name: "Network", targets: ["Network"]),
        .library(name: "ContentProvider", targets: ["ContentProvider"]),
        .library(name: "Publishers", targets: ["Publishers"]),
        .library(name: "QueryParameters", targets: ["QueryParameters"]),
        .library(name: "WeatherIcons", targets: ["WeatherIcons"]),
        .library(name: "Formatters", targets: ["Formatters"]),
        .library(name: "Astronomy", targets: ["Astronomy"]),
        .library(name: "Fixtures", targets: ["Fixtures"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/andyshep/Waypoints", .branch("master")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: "Model", dependencies: []),
        .testTarget(name: "ModelTests", dependencies: ["Model"]),
        .target(name: "ViewModel", dependencies: ["Model", "WeatherIcons", "Formatters"]),
        .target(name: "View", dependencies: ["ViewModel", "Astronomy"]),
        .target(name: "Network", dependencies: ["Publishers", "QueryParameters"]),
        .target(name: "ContentProvider", dependencies: ["Waypoints", "ViewModel", "Model", "Network"]),
        .target(name: "Publishers", dependencies: []),
        .target(name: "QueryParameters", dependencies: []),
        .target(name: "WeatherIcons", dependencies: []),
        .target(name: "Formatters", dependencies: []),
        .target(name: "Astronomy", dependencies: []),
        .target(name: "Fixtures", dependencies: ["Model"]),
    ]
)

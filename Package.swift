// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "NEMA-Steppers",
	platforms: [.macOS(.v15)],
	products: [
		.library(name: "NEMA", targets: ["NEMA"]),
		.executable(name: "NEMA-Demo", targets: ["Demo"]),
	],
	dependencies: [
		.package(url: "https://github.com/tomasf/Cadova.git", from: "1.0.0"),
	],
	targets: [
		// Targets are the basic building blocks of a package, defining a module or a test suite.
		// Targets can depend on other targets in this package and products from dependencies.
		.target(
			name: "NEMA",
			dependencies: ["Cadova"],
			swiftSettings: [.interoperabilityMode(.Cxx)]
		),
		.executableTarget(
			name: "Demo",
			dependencies: ["Cadova", "NEMA"],
			swiftSettings: [.interoperabilityMode(.Cxx)]
		),
		.testTarget(
			name: "NEMATests",
			dependencies: ["NEMA", "Cadova"],
			swiftSettings: [.interoperabilityMode(.Cxx)]
		),
	],
	swiftLanguageModes: [.v6]
)

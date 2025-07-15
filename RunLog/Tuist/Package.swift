// swift-tools-version: 6.0
import PackageDescription

#if TUIST
import struct ProjectDescription.PackageSettings

let packageSettings = PackageSettings(
  // Customize the product types for specific package product
  // Default is .staticFramework
  // productTypes: ["Alamofire": .framework,]
  productTypes: [:]
)
#endif

let package = Package(
  name: "RunLogPackages",
  dependencies: [
    .package(url: "https://github.com/SnapKit/SnapKit", from: "5.7.1"),
    .package(url: "https://github.com/devxoul/Then", from: "3.0.0"),
    .package(url: "https://github.com/Moya/Moya.git", from: "15.0.3"),
    .package(url: "https://github.com/ninjaprox/NVActivityIndicatorView", from: "5.2.0")
  ]
)

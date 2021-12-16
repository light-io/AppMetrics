// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "AppMetrics",
  platforms: [.iOS(.v15), .macOS(.v12)],
  products: [
    .library(name: "AppMetrics", targets: ["AppMetrics"]),
    .library(name: "AppMetricsKit", targets: ["AppMetricsKit"])
  ],
  dependencies: [
    .package(url: "https://github.com/light-io/CommonUtils.git", .upToNextMajor(from: "1.0.0")),
  ],
  targets: [
    .target(name: "AppMetrics", dependencies: ["CommonUtils"]),
    .target(name: "AppMetricsKit", dependencies: ["AppMetrics"]),
  ],
  swiftLanguageVersions: [.v5]
)

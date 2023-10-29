// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "VoiceMemo",
  platforms: [
    .iOS(.v17),
  ],
  products: [
    .library(
      name: "VoiceMemo",
      targets: ["VoiceMemo"]),
  ],
  dependencies: [
    .package(path: "../../Core/Architecture"),
  ],
  targets: [
    .target(
      name: "VoiceMemo",
      dependencies: [
        "Architecture",
      ]),
    .testTarget(
      name: "VoiceMemoTests",
      dependencies: ["VoiceMemo"]),
  ])

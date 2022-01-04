// swift-tools-version: 5.6
import PackageDescription

let package = Package(
  name: "SwiftGen",
  platforms: [
    .macOS(.v10_11),
  ],
  products: [
    .executable(name: "swiftgen", targets: ["SwiftGen"]),
    .library(name: "SwiftGenCLI", targets: ["SwiftGenCLI"]),
    .library(name: "SwiftGenKit", targets: ["SwiftGenKit"]),
  ],
  dependencies: [
    .package(url: "https://github.com/jpsim/Yams.git", from: "4.0.6"),
    .package(url: "https://github.com/kylef/Commander.git", from: "0.9.1"),
    .package(url: "https://github.com/kylef/PathKit.git", from: "1.0.1"),
    .package(url: "https://github.com/kylef/Stencil.git", from: "0.14.1"),
    .package(url: "https://github.com/shibapm/Komondor.git", from: "1.1.1"),
    .package(url: "https://github.com/SwiftGen/StencilSwiftKit.git", from: "2.8.0"),
    .package(url: "https://github.com/tid-kijyun/Kanna.git", from: "5.2.7")
  ],
  targets: [
    .executableTarget(name: "SwiftGen", dependencies: [
      "SwiftGenCLI"
    ]),
    .target(name: "SwiftGenCLI", dependencies: [
      "Commander",
      "Kanna",
      "PathKit",
      "Stencil",
      "StencilSwiftKit",
      "SwiftGenKit",
      "Yams"
    ], resources: [
      .copy("templates")
    ]),
    .target(name: "SwiftGenKit", dependencies: [
      "Kanna",
      "PathKit",
      "Yams"
    ]),
    .testTarget(name: "SwiftGenKitTests", dependencies: [
      "SwiftGenKit",
      "TestUtils"
    ]),
    .testTarget(name: "SwiftGenTests", dependencies: [
      "SwiftGenCLI",
      "TestUtils"
    ]),
    .testTarget(name: "TemplatesTests", dependencies: [
      "StencilSwiftKit",
      "SwiftGenKit",
      "TestUtils"
    ]),
    .target(name: "TestUtils", dependencies: [
      "PathKit",
      "SwiftGenKit",
      "SwiftGenCLI"
    ], exclude: [
      "Fixtures/CompilationEnvironment"
    ], resources: [
      .copy("Fixtures/Configs"),
      .copy("Fixtures/Generated"),
      .copy("Fixtures/Resources"),
      .copy("Fixtures/StencilContexts")
    ]),
    /// Package plugin that tells SwiftPM how to run `swiftgen` based on
    /// the configuration file. Client targets use this plugin by listing
    /// it in their `plugins` parameter.
    .plugin(
        name: "SwiftGenPlugin",
        capability: .buildTool(),
        dependencies: ["SwiftGen"]
    ),
  ],
  swiftLanguageVersions: ["5.6"]
)

#if canImport(PackageConfig)
import PackageConfig

let config = PackageConfiguration([
  "komondor": [
    "pre-commit": [
        "PATH=\"~/.rbenv/shims:$PATH\" bundler exec rake lint:code",
        "PATH=\"~/.rbenv/shims:$PATH\" bundler exec rake lint:tests",
        "PATH=\"~/.rbenv/shims:$PATH\" bundler exec rake lint:output"
    ],
    "pre-push": [
      "PATH=\"~/.rbenv/shims:$PATH\" bundle exec rake spm:test"
    ]
  ],
]).write()
#endif

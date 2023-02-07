// swift-tools-version:5.7.1
import PackageDescription

let package = Package(
    name: "Run",
    platforms: [
       .macOS(.v12)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/vapor/leaf.git", from: "4.0.0"),
        .package(url: "https://github.com/GraphQLSwift/Graphiti.git", from: "0.25.0"),
        //.package(url: "https://github.com/IBM-Swift/BlueECC.git", from: "1.2.4"),
        //.package(url: "https://github.com/IBM-Swift/Swift-JWT.git", from: "3.5.3")

        
        
    ],
    targets: [
        .target(name: "Run",dependencies: [.target(name: "App")]),
        .target(
            name: "App",
            dependencies: [
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "Leaf", package: "leaf"),
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Graphiti", package: "graphiti"),
              //  .product(name: "CryptorECC", package: "BlueECC"),
              //  .product(name: "SwiftJWT", package: "Swift-JWT"),
            ],
            swiftSettings: [
                // Enable better optimizations when building in Release configuration. Despite the use of
                // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                // builds. See <https://github.com/swift-server/guides/blob/main/docs/building.md#building-for-production> for details.
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
//        .executableTarget(name: "Run", dependencies: [.target(name: "App")]),
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
            .product(name: "XCTVapor", package: "vapor"),
        ])
    ]
)

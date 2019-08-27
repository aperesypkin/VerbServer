// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "VerbServer",
    products: [
        .library(name: "VerbServer", targets: ["App"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework
        .package(url: "https://github.com/vapor/vapor.git", .exact("3.3.0")),

        // 🖋🐘 Swift ORM (queries, models, relations, etc) built on PostgreSQL
        .package(url: "https://github.com/vapor/fluent-postgresql", .exact("1.0.0")),
        
        // 👤 Authentication and Authorization framework for Fluent
        .package(url: "https://github.com/vapor/auth.git", .exact("2.0.4")),
        
        // 🍃 An expressive, performant, and extensible templating language built for Swift
        .package(url: "https://github.com/vapor/leaf.git", .exact("3.0.2"))
    ],
    targets: [
        .target(name: "App", dependencies: ["Vapor", "FluentPostgreSQL", "Authentication", "Leaf"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)


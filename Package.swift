import PackageDescription

let package = Package(
    name: "Nifty",
    dependencies: [
        .Package(url: "https://github.com/nifty-swift/CLapacke.git", majorVersion: 1)
    ]
)
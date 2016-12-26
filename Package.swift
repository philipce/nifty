import PackageDescription

let package = Package(
    name: "Nifty",
    dependencies: [
        .Package(url: "https://github.com/nifty-swift/Nifty-libs.git", majorVersion: 1),
    ],
    exclude: [
    	"Tests/KnownResults",
    ]

)
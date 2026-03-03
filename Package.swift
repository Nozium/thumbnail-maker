// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "ThumbnailMaker",
    platforms: [.macOS(.v14), .iOS(.v17)],
    targets: [
        .executableTarget(
            name: "ThumbnailMaker",
            path: "Sources"
        )
    ]
)

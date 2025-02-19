// swift-tools-version:5.9

import PackageDescription

// Define libxml2 only on Linux, since it causes warnings
// about "pkgconfig not found" on Mac
#if os(Linux)
let libXML2DependencyOrNil: Target.Dependency? = "libxml2"
let libXML2TargetOrNil: Target? = Target.systemLibrary(
    name: "libxml2",
    pkgConfig: "libxml-2.0",
    providers: [
        .apt(["libxml2 libxml2-dev"]),
        .yum(["libxml2 libxml2-devel"])
    ]
)
#else
let libXML2DependencyOrNil: Target.Dependency? = nil
let libXML2TargetOrNil: Target? = nil
#endif

let package = Package(
    name: "smithy-swift",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(name: "Smithy", targets: ["Smithy"]),
        .library(name: "ClientRuntime", targets: ["ClientRuntime"]),
        .library(name: "SmithyRetriesAPI", targets: ["SmithyRetriesAPI"]),
        .library(name: "SmithyRetries", targets: ["SmithyRetries"]),
        .library(name: "SmithyReadWrite", targets: ["SmithyReadWrite"]),
        .library(name: "SmithyXML", targets: ["SmithyXML"]),
        .library(name: "SmithyJSON", targets: ["SmithyJSON"]),
        .library(name: "SmithyFormURL", targets: ["SmithyFormURL"]),
        .library(name: "SmithyTimestamps", targets: ["SmithyTimestamps"]),
        .library(name: "SmithyIdentity", targets: ["SmithyIdentity"]),
        .library(name: "SmithyIdentityAPI", targets: ["SmithyIdentityAPI"]),
        .library(name: "SmithyHTTPAPI", targets: ["SmithyHTTPAPI"]),
        .library(name: "SmithyHTTPAuth", targets: ["SmithyHTTPAuth"]),
        .library(name: "SmithyHTTPAuthAPI", targets: ["SmithyHTTPAuthAPI"]),
        .library(name: "SmithyEventStreamsAPI", targets: ["SmithyEventStreamsAPI"]),
        .library(name: "SmithyEventStreamsAuthAPI", targets: ["SmithyEventStreamsAuthAPI"]),
        .library(name: "SmithyEventStreams", targets: ["SmithyEventStreams"]),
        .library(name: "SmithyStreams", targets: ["SmithyStreams"]),
        .library(name: "SmithyChecksumsAPI", targets: ["SmithyChecksumsAPI"]),
        .library(name: "SmithyChecksums", targets: ["SmithyChecksums"]),
        .library(name: "SmithyWaitersAPI", targets: ["SmithyWaitersAPI"]),
        .library(name: "SmithyTestUtil", targets: ["SmithyTestUtil"]),
    ],
    dependencies: [
        .package(url: "https://github.com/awslabs/aws-crt-swift.git", exact: "0.32.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "Smithy",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
            ]
        ),
        .target(
            name: "ClientRuntime",
            dependencies: [
                "Smithy",
                "SmithyRetriesAPI",
                "SmithyRetries",
                "SmithyXML",
                "SmithyJSON",
                "SmithyFormURL",
                "SmithyIdentity",
                "SmithyIdentityAPI",
                "SmithyHTTPAPI",
                "SmithyHTTPAuth",
                "SmithyHTTPAuthAPI",
                "SmithyEventStreamsAPI",
                "SmithyEventStreams",
                "SmithyEventStreamsAuthAPI",
                "SmithyStreams",
                "SmithyChecksumsAPI",
                "SmithyChecksums",
                .product(name: "AwsCommonRuntimeKit", package: "aws-crt-swift"),
            ],
            resources: [
                .copy("PrivacyInfo.xcprivacy")
            ]
        ),
        .target(
            name: "SmithyRetriesAPI"
        ),
        .target(
            name: "SmithyRetries",
            dependencies: [
                "SmithyRetriesAPI",
                .product(name: "AwsCommonRuntimeKit", package: "aws-crt-swift"),
            ]
        ),
        .target(
            name: "SmithyReadWrite",
            dependencies: ["SmithyTimestamps"]
        ),
        .target(
            name: "SmithyXML",
            dependencies: [
                "SmithyReadWrite",
                "SmithyTimestamps",
                libXML2DependencyOrNil
            ].compactMap { $0 }
        ),
        .target(
            name: "SmithyJSON",
            dependencies: [
                "SmithyReadWrite",
                "SmithyTimestamps"
            ]
        ),
        .target(
            name: "SmithyFormURL",
            dependencies: [
                "SmithyReadWrite",
                "SmithyTimestamps"
            ]
        ),
        libXML2TargetOrNil,
        .target(
            name: "SmithyTimestamps"
        ),
        .target(
            name: "SmithyTestUtil",
            dependencies: ["ClientRuntime", "SmithyHTTPAPI"]
        ),
        .target(
            name: "SmithyIdentity",
            dependencies: [
                "SmithyIdentityAPI",
                .product(name: "AwsCommonRuntimeKit", package: "aws-crt-swift")
            ]
        ),
        .target(
            name: "SmithyIdentityAPI",
            dependencies: ["Smithy"]
        ),
        .target(
            name: "SmithyHTTPAPI",
            dependencies: ["Smithy"]
        ),
        .target(
            name: "SmithyHTTPAuth",
            dependencies: [
                "Smithy",
                "SmithyHTTPAuthAPI",
                "SmithyIdentity",
                "SmithyIdentityAPI",
                .product(name: "AwsCommonRuntimeKit", package: "aws-crt-swift")
            ]
        ),
        .target(
            name: "SmithyHTTPAuthAPI",
            dependencies: ["Smithy", "SmithyHTTPAPI", "SmithyIdentityAPI"]
        ),
        .target(
            name: "SmithyEventStreamsAPI",
            dependencies: ["Smithy"]
        ),
        .target(
            name: "SmithyEventStreamsAuthAPI",
            dependencies: ["Smithy", "SmithyEventStreamsAPI"]
        ),
        .target(
            name: "SmithyEventStreams",
            dependencies: [
                "Smithy",
                "SmithyEventStreamsAPI",
                "SmithyEventStreamsAuthAPI",
                .product(name: "AwsCommonRuntimeKit", package: "aws-crt-swift")
            ]
        ),
        .target(
            name: "SmithyStreams",
            dependencies: [
                "Smithy",
                .product(name: "Logging", package: "swift-log"),
                .product(name: "AwsCommonRuntimeKit", package: "aws-crt-swift")
            ]
        ),
        .target(
            name: "SmithyChecksumsAPI",
            dependencies: ["Smithy"]
        ),
        .target(
            name: "SmithyChecksums",
            dependencies: [
                "Smithy",
                "SmithyChecksumsAPI",
                "SmithyStreams",
                "SmithyHTTPAuth",
                .product(name: "AwsCommonRuntimeKit", package: "aws-crt-swift")
            ]
        ),
        .target(
            name: "SmithyWaitersAPI"
        ),
        .testTarget(
            name: "ClientRuntimeTests",
            dependencies: ["ClientRuntime", "SmithyTestUtil", "SmithyStreams"],
            resources: [ .process("Resources") ]
        ),
        .testTarget(
            name: "SmithyXMLTests",
            dependencies: ["SmithyXML", "ClientRuntime"]
        ),
        .testTarget(
            name: "SmithyJSONTests",
            dependencies: ["SmithyJSON", "ClientRuntime"]
        ),
        .testTarget(
            name: "SmithyFormURLTests",
            dependencies: ["SmithyFormURL", "ClientRuntime"]
        ),
        .testTarget(
            name: "SmithyTimestampsTests",
            dependencies: ["SmithyTimestamps"]
        ),
        .testTarget(
            name: "SmithyTestUtilTests",
            dependencies: ["SmithyTestUtil"]
        ),
        .testTarget(
            name: "SmithyEventStreamsTests",
            dependencies: ["SmithyEventStreams"]
        ),
        .testTarget(
            name: "SmithyIdentityTests",
            dependencies: ["Smithy", "SmithyIdentity"]
        ),
        .testTarget(
            name: "SmithyWaitersAPITests",
            dependencies: ["Smithy", "SmithyWaitersAPI"]
        ),
    ].compactMap { $0 }
)

import ProjectDescription

let project1 = Project(
    name: "RLDesignSystem",
    organizationName: "ESTSOFTiOSTEAM1",
    targets: [
        .target(
            name: "RLDesignSystem",
            destinations: [.iPhone],
            product: .staticFramework,
            bundleId: "com.ESTSOFTiOSTEAM1.IEEE.RLDesignSystem",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .file(path: "InfoPlists/RLDesignSystem-info.plist"),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .external(name: "SnapKit"),
                .external(name: "Then"),
                .external(name: "NVActivityIndicatorView"),
                .external(name: "NVActivityIndicatorViewExtended")
            ]
        )
    ]
)

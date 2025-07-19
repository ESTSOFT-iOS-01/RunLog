import ProjectDescription

let project = Project(
    name: "RLApp",
    organizationName: "ESTSOFTiOSTEAM1",
    targets: [
        .target(
            name: "RLApp",
            destinations: [.iPhone],
            product: .app,
            bundleId: "com.ESTSOFTiOSTEAM1.IEEE.RunLog",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .file(path: "InfoPlists/RunLog-info.plist"),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .external(name: "SnapKit"),
                .external(name: "Then"),
                .external(name: "Moya"),
                .external(name: "CombineMoya"),
                .external(name: "NVActivityIndicatorView"),
                .external(name: "NVActivityIndicatorViewExtended"),
                .project(target: "RLUtil", path: "../Util"),
                .project(target: "RLDesignSystem", path: "../DesignSystem")
            ],
            coreDataModels: [
                .coreDataModel("Sources/Data/DTO/DTOs.xcdatamodeld")
            ]
        ),
    ]
)


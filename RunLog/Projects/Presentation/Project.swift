import ProjectDescription

let project1 = Project(
    name: "RLPresentation",
    organizationName: "ESTSOFTiOSTEAM1",
    targets: [
        .target(
            name: "RLPresentation",
            destinations: [.iPhone],
            product: .staticFramework,
            bundleId: "com.ESTSOFTiOSTEAM1.IEEE.RLPresentation",
            deploymentTargets: .iOS("17.0"),
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .external(name: "SnapKit"),
                .external(name: "Then"),
                .external(name: "NVActivityIndicatorView"),
                .external(name: "NVActivityIndicatorViewExtended"),
                .project(target: "RLInject", path: "../Inject"),
                .project(target: "RLDomain", path: "../Domain"),
                .project(target: "RLData", path: "../Data"), // 수정해야됨
                .project(target: "RLUtil", path: "../Util"),
                .project(target: "RLDesignSystem", path: "../DesignSystem")
            ]
        )
    ]
)

import ProjectDescription

let project1 = Project(
    name: "RLDomain",
    organizationName: "ESTSOFTiOSTEAM1",
    targets: [
        .target(
            name: "RLDomain",
            destinations: [.iPhone],
            product: .staticFramework,
            bundleId: "com.ESTSOFTiOSTEAM1.IEEE.RLDomain",
            deploymentTargets: .iOS("17.0"),
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .project(target: "RLUtil", path: "../Util"),
                .project(target: "RLDesignSystem", path: "../DesignSystem") // 수정 해야함,,
            ]
        )
    ]
)

import ProjectDescription

let project1 = Project(
    name: "RLInject",
    organizationName: "ESTSOFTiOSTEAM1",
    targets: [
        .target(
            name: "RLInject",
            destinations: [.iPhone],
            product: .staticFramework,
            bundleId: "com.ESTSOFTiOSTEAM1.IEEE.RLInject",
            deploymentTargets: .iOS("17.0"),
            sources: ["Sources/**"],
            resources: [],
            dependencies: []
        )
    ]
)

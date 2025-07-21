import ProjectDescription

let project1 = Project(
    name: "RLData",
    organizationName: "ESTSOFTiOSTEAM1",
    targets: [
        .target(
            name: "RLData",
            destinations: [.iPhone],
            product: .framework,
            bundleId: "com.ESTSOFTiOSTEAM1.IEEE.RLData",
            deploymentTargets: .iOS("17.0"),
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .project(target: "RLDomain", path: "../Domain"),
                .project(target: "RLUtil", path: "../Util"),
            ],
            coreDataModels: [
                .coreDataModel("Sources/DTO/DTOs.xcdatamodeld")
            ]
        )
    ]
)

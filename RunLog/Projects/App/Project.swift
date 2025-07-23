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
                .project(target: "RLInject", path: "../Inject"),
                .project(target: "RLDomain", path: "../Domain"),
                .project(target: "RLData", path: "../Data"),
                .project(target: "RLPresentation", path: "../Presentation"),
                .project(target: "RLUtil", path: "../Util"),
            ]
        ),
    ]
)


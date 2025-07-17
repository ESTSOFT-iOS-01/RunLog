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
      infoPlist: .file(path: "../../RunLog/App/InfoPlists/RunLog-info.plist"),
      sources: ["../../RunLog/App/Sources/**"],
      resources: [
        "../../RunLog/App/Resources/**",
        "../../RunLog/App/DesignSystem/Resources/**"
      ],
      dependencies: [
        .external(name: "SnapKit"),
        .external(name: "Then"),
        .external(name: "Moya"),
        .external(name: "CombineMoya"),
        .external(name: "NVActivityIndicatorView"),
        .external(name: "NVActivityIndicatorViewExtended"),
        .project(target: "RLUtil", path: "../Util")
      ],
      coreDataModels: [
        .coreDataModel("../../RunLog/App/Sources/Data/DTO/DTOs.xcdatamodeld")
      ]
    ),
    .target(
      name: "RpTest",
      destinations: [.iPhone],
      product: .unitTests,
      bundleId: "com.ESTSOFTiOSTEAM1.IEEE.RpTest",
      deploymentTargets: .iOS("17.0"),
      infoPlist: .file(path: "../../RpTest/InfoPlists/RpTest-info.plist"),
      sources: ["../../RpTest/Sources/**"],
      dependencies: [
        .target(name: "RLApp")
      ]
    )
  ]
)


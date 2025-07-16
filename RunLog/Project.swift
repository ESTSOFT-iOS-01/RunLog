import ProjectDescription

let project = Project(
  name: "RunLog",
  organizationName: "ESTSOFTiOSTEAM1",
  targets: [
    .target(
      name: "RunLog",
      destinations: [.iPhone],
      product: .app,
      bundleId: "com.ESTSOFTiOSTEAM1.IEEE.RunLog",
      deploymentTargets: .iOS("17.0"),
      infoPlist: .file(path: "RunLog/InfoPlists/RunLog-info.plist"),
      sources: ["RunLog/Sources/**"],
      resources: ["RunLog/Resources/**"],
      dependencies: [
        .external(name: "SnapKit"),
        .external(name: "Then"),
        .external(name: "Moya"),
        .external(name: "CombineMoya"),
        .external(name: "NVActivityIndicatorView"),
        .external(name: "NVActivityIndicatorViewExtended"),
      ],
      coreDataModels: [
        .coreDataModel("RunLog/Sources/Data/DTO/DTOs.xcdatamodeld")
      ]
    ),
    .target(
      name: "RpTest",
      destinations: [.iPhone],
      product: .unitTests,
      bundleId: "com.ESTSOFTiOSTEAM1.IEEE.RpTest",
      deploymentTargets: .iOS("17.0"),
      infoPlist: .file(path: "RpTest/InfoPlists/RpTest-info.plist"),
      sources: ["RpTest/Sources/**"],
      dependencies: [
        .target(name: "RunLog")
      ]
    )
  ]
)

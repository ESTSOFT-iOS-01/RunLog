import ProjectDescription

let project1 = Project(
  name: "RLUtil",
  organizationName: "ESTSOFTiOSTEAM1",
  targets: [
    .target(
      name: "RLUtil",
      destinations: [.iPhone],
      product: .staticFramework,
      bundleId: "com.ESTSOFTiOSTEAM1.IEEE.RLUtil",
      deploymentTargets: .iOS("17.0"),
      sources: ["Sources/**"],
      resources: []
    )
  ]
)

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
      infoPlist: .extendingDefault(
        with: [
          "API_KEY": "$(API_KEY)",
          "NSRemoteNotificationUsageDescription": "푸시 알림을 통해 개인화된 최신 소식을 받아보세요.",
          "UIAppFonts": [
            "NanumMyeongjo-Regular.ttf",
            "RacingSansOne-Regular.ttf",
            "Pretendard-Black.otf",
            "Pretendard-Bold.otf",
            "Pretendard-ExtraBold.otf",
            "Pretendard-ExtraLight.otf",
            "Pretendard-Light.otf",
            "Pretendard-Medium.otf",
            "Pretendard-Regular.otf",
            "Pretendard-SemiBold.otf",
            "Pretendard-Thin.otf",
          ],
          "UIBackgroundModes": ["location"],
          "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": false,
            "UISceneConfigurations": [
              "UIWindowSceneSessionRoleApplication": [
                [
                  "UISceneConfigurationName": "Default Configuration",
                  "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                ]
              ]
            ]
          ],
          "NSAppTransportSecurity": [
            "NSAllowsArbitraryLoads": true
          ],
          "UILaunchScreen": [
            "UIColorName": "",
            "UIImageName": "",
          ],
        ]
      ),
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
      infoPlist: .default,
      sources: ["RpTest/**"],
      dependencies: [
        .target(name: "RunLog")
      ]
    )
  ]
)

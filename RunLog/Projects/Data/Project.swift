import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
    name: Module.data.name,
    organizationName: Module.organizationName,
    infoPlist: .default,
    dependencies: [
        Module.inject.project,
        Module.domain.project,
        Module.util.project,
        .external(name: "Moya"),
        .external(name: "CombineMoya"),
    ],
    coreDataModels: [
        .coreDataModel("Sources/DTOs/DTOs.xcdatamodeld")
    ]
)

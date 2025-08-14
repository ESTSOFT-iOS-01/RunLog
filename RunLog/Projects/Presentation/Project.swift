import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
    name: Module.presentation.name,
    organizationName: Module.organizationName,
    infoPlist: .default,
    dependencies: [
        Module.inject.project,
        Module.domain.project,
        Module.data.project, // 수정해야함
        Module.util.project,
        Module.designSystem.project,
        .external(name: "SnapKit"),
        .external(name: "Then"),
        .external(name: "NVActivityIndicatorView"),
        .external(name: "NVActivityIndicatorViewExtended"),
    ]
)

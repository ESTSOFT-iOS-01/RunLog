import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
    name: Module.util.name,
    organizationName: Module.organizationName,
    infoPlist: .default,
    dependencies: [
        .external(name: "SnapKit"),
    ]
)

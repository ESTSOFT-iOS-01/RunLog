import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
    name: Module.domain.name,
    organizationName: Module.organizationName,
    infoPlist: .default,
    dependencies: [
        Module.util.project,
        Module.designSystem.project
    ]
)

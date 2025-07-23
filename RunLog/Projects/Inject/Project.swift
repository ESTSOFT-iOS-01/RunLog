import ProjectDescription

import ProjectDescriptionHelpers

let project = Project.framework(
    name: Module.inject.name,
    organizationName: Module.organizationName,
    infoPlist: .default
)

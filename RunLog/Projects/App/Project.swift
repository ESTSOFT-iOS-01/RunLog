import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
    name: Module.app.name,
    organizationName: Module.organizationName,
    infoPlist: .file(path: "InfoPlists/info.plist"),
    dependencies: [
        Module.inject,
        Module.domain,
        Module.data,
        Module.presentation,
        Module.util,
    ].map(\.project),
    resources: .default
)

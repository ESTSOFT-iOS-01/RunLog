import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
    name: Module.designSystem.name,
    organizationName: Module.organizationName,
    infoPlist: .file(path: "InfoPlists/info.plist"),
    dependencies: [
        Module.util.project,
        .external(name: "SnapKit"),
        .external(name: "Then"),
        .external(name: "NVActivityIndicatorView"),
    ],
    resources: .default
)

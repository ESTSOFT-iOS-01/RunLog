import ProjectDescription
import ProjectDescriptionHelpers

let workspace = Workspace(
    name: "RunLog",
    projects: Module.allCases.map(\.path)
)

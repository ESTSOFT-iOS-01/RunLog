import ProjectDescription

extension Project {
    public static func project(
        name: String,
        organizationName: String,
        product: Product,
        bundleID: String,
        infoPlist: InfoPlist?,
        schemes: [Scheme] = [],
        dependencies: [TargetDependency] = [],
        resources: ProjectDescription.ResourceFileElements? = nil,
        coreDataModels: [CoreDataModel] = []
    ) -> Project {
        return Project(
            name: name,
            organizationName: organizationName,
            targets: [
                .target(
                    name: name,
                    destinations: [.iPhone],
                    product: product,
                    bundleId: bundleID,
                    deploymentTargets: .iOS("17.0"),
                    infoPlist: infoPlist,
                    sources: ["Sources/**"],
                    resources: resources,
                    dependencies: dependencies,
                    coreDataModels: coreDataModels
                ),
                .target(
                    name: "\(name)Tests",
                    destinations: [.iPhone],
                    product: .unitTests,
                    bundleId: bundleID,
                    deploymentTargets: .iOS("17.0"),
                    infoPlist: infoPlist,
                    sources: "Tests/**",
                    dependencies: [
                        .target(name: "\(name)")
                    ]
                )
            ],
            schemes: schemes
        )
    }
    
    public static func app (
            name: String,
            organizationName: String,
            infoPlist: InfoPlist?,
            dependencies: [TargetDependency] = [],
            resources: ProjectDescription.ResourceFileElements? = nil
        ) -> Project {
            return self.project(
                name: "RL\(name)",
                organizationName: organizationName,
                product: .app,
                bundleID: "com.\(organizationName).\(name)",
                infoPlist: infoPlist,
                dependencies: dependencies,
                resources: resources
            )
        }
    
    public static func framework(
        name: String,
        organizationName: String,
        infoPlist: InfoPlist?,
        dependencies: [TargetDependency] = [],
        resources: ProjectDescription.ResourceFileElements? = nil,
        coreDataModels: [CoreDataModel] = []
        ) -> Project {
            return .project(
                name: "RL\(name)",
                organizationName: organizationName,
                product: .framework,
                bundleID: "com.\(organizationName).RL\(name)",
                infoPlist: infoPlist,
                dependencies: dependencies,
                resources: resources,
                coreDataModels: coreDataModels
            )
        }
}

public extension ProjectDescription.ResourceFileElements {

    static let `default`: ProjectDescription.ResourceFileElements = ["Resources/**"]

}

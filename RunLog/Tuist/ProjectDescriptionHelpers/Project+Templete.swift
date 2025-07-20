import ProjectDescription

extension Project {
    public static func project(
        name: String,
        organizationName: String,
        product: Product,
        bundleID: String,
        schemes: [Scheme] = [],
        dependencies: [TargetDependency] = [],
        resources: ProjectDescription.ResourceFileElements? = nil
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
                    infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
                    sources: ["Sources/**"],
                    resources: resources,
                    dependencies: dependencies
                ),
                .target(
                    name: "\(name)Tests",
                    destinations: [.iPhone],
                    product: .unitTests,
                    bundleId: bundleID,
                    deploymentTargets: .iOS("17.0"),
                    infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
                    sources: "Tests/**",
                    dependencies: [
                        .target(name: "\(name)")
                    ]
                )
            ],
            schemes: schemes
        )
    }
    
    public static func app(
            name: String,
            organizationName: String,
            dependencies: [TargetDependency] = [],
            resources: ProjectDescription.ResourceFileElements? = nil
        ) -> Project {
            return self.project(
                name: name,
                organizationName: organizationName,
                product: .app,
                bundleID: "com.\(organizationName).\(name)",
                dependencies: dependencies,
                resources: resources
            )
        }
    
    public static func framework(
        name: String,
        organizationName: String,
        dependencies: [TargetDependency] = [],
        resources: ProjectDescription.ResourceFileElements? = nil
        ) -> Project {
            return .project(
                name: name,
                organizationName: organizationName,
                product: .framework,
                bundleID: "com.\(organizationName).\(name)",
                dependencies: dependencies,
                resources: resources
            )
        }
}

public extension ProjectDescription.ResourceFileElements {

    static let `default`: ProjectDescription.ResourceFileElements = ["Resources/**"]

}

import ProjectDescription

public enum Module {
    case app
    case data
    case presentation
    case domain
    case designSystem
    case util
    case inject
}

extension Module {
    public var name: String {
        switch self {
        case .app: 
            "App"
        case .data:
            "Data"
        case .presentation:
            "Presentation"
        case .domain:
            "Domain"
        case .designSystem:
            "DesignSystem"
        case .util:
            "Util"
        case .inject:
            "Inject"
        }
    }
    
    public static let organizationName: String = "ESTSOFTiOSTEAM1"
    
    public var path: ProjectDescription.Path {
        .relativeToRoot("Projects/" + self.name)
    }
    
    public var project: TargetDependency {
        .project(target: "RL\(self.name)", path: self.path)
    }
}

extension Module: CaseIterable { }

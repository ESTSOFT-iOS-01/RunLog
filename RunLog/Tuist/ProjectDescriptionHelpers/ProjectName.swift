import ProjectDescription

public enum Module {
    case app
    case data
    case presentation
    case domain
    case designSystem
    case util
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
        }
    }
    
    public static let organizationName: String = "ESTSOFTiOSTEAM1"
    
    public static let prefixText: String = "RL"
    
    public var path: ProjectDescription.Path {
        .relativeToRoot("Projects/" + self.name)
    }
    
    public var project: TargetDependency {
        .project(target: self.prefixText + self.name, path: self.path)
    }
}

extension Module: CaseIterable { }

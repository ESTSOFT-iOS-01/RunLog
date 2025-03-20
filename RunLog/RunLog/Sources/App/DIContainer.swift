//
//  DIContainer.swift
//  RunLog
//
//  Created by 신승재 on 3/20/25.
//

import Foundation

class DIContainer {
    
    static let shared = DIContainer()
    
    private var dependencies = [String: Any]()
    
    private init() {}

    func register<T>(_ dependency: T) {
        let key = String(describing: type(of: T.self))
        dependencies[key] = dependency
    }
    
    func resolve<T>() -> T {
        let key = String(describing: type(of: T.self))
        let dependency = dependencies[key]
        
        precondition(
            dependency != nil, "\(key)는 register되지 않았어어요. resolve 부르기전에 register 해주세요"
        )
        
        return dependency as! T
    }
}

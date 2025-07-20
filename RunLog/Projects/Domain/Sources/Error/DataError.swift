//
//  DataError.swift
//  RLDomain
//
//  Created by 신승재 on 7/20/25.
//  Copyright © 2025 ESTSOFTiOSTEAM1. All rights reserved.
//

import Foundation

public enum DataError: LocalizedError {
    case fetchError
    case deleteError
    case modelNotFound
    case modelAlreadyExist
    case conversionError
    
    var errorDescription: String {
        switch self {
        case .fetchError:
            "Fetch Error"
        case .deleteError:
            "Delete Error"
        case .modelNotFound:
            "Model Not Found"
        case .modelAlreadyExist:
            "Model Already Exist"
        case .conversionError:
            "Conversion Error"
        }
    }
}

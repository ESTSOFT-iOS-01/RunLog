//
//  IconSystem.swift
//  RunLog
//
//  Created by 심근웅 on 3/14/25.
//

import Foundation

// MARK: - 아이콘
enum RLIcon {
    case ellipsis
    case walk
    case rightArrow
    case leftArrow
    case document
    case streak
    case rightChevron
    case play
    case mappin
    case weather
    case dumbell
    case fold
    case unfold
    
    case selectedCircle
    case unslectedCircle
    
    case noneBeat
    case oneBeat
    case twoBeats
    case threeBeats
    
    case rocket
    case church
    case earth
    case flag
    case korea
    case mandarin
    case medal
}

extension RLIcon {
    var name: String {
        switch self {
        case .fold:
            return "xmark"
        case .walk:
            return "walk"
        case .rightArrow:
            return "arrowtriangle.right.fill"
        case .leftArrow:
            return "arrowtriangle.left.fill"
        case .document:
            return "text.document"
        case .streak:
            return "leaf"
        case .rightChevron:
            return "chevron.right"
        case .unfold:
            return "heart.text.square"
        case .weather:
            return "thermometer.medium"
        case .play:
            return "play"
        case .mappin:
            return "mappin.and.ellipse"
        case .dumbell:
            return "dumbbell"
            
        case .selectedCircle:
            return "inset.filled.circle"
        case .unslectedCircle:
            return "circle"
            
        case .noneBeat:
            return "noneBeat"
        case .oneBeat:
            return "oneBeat"
        case .twoBeats:
            return "twoBeats"
        case .threeBeats:
            return "threeBeats"
        case .rocket:
            return "Rocket"
        case .church:
            return "Church"
        case .earth:
            return "Earth"
        case .flag:
            return "Flag"
        case .korea:
            return "Korea"
        case .mandarin:
            return "Mandarin"
        case .medal:
            return "Medal"
        case .ellipsis:
            return "ellipsis"
        }
    }
}

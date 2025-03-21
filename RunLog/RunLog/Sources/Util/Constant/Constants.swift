//
//  Constants.swift
//  RunLog
//
//  Created by 김도연 on 3/21/25.
//

import Foundation

struct Constants {
    static let allRoads: [Road] = [
        Road(name: "마라톤", distance: 42.195, icon: RLIcon.medal.name),
        Road(name: "서울둘레길", distance: 156.5, icon: RLIcon.flag.name),
        Road(name: "제주올레길", distance: 437.0, icon: RLIcon.mandarin.name),
        Road(name: "국토대장정", distance: 580.0, icon: RLIcon.korea.name),
        Road(name: "산티아고 순례길", distance: 800.0, icon: RLIcon.church.name),
        Road(name: "지구 둘레길", distance: 40075, icon: RLIcon.earth.name),
        Road(name: "지구에서 달까지", distance: 385000, icon: RLIcon.rocket.name)
    ]
}

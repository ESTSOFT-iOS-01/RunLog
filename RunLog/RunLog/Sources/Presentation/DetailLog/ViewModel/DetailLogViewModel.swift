//
//  DetailLogViewModel.swift
//  RunLog
//
//  Created by 도민준 on 3/17/25.
//

import UIKit
import Combine
import MapKit

final class DetailLogViewModel {
    
    // MARK: - Properties
    let dayLog: DayLog  // 외부에서 주입되는 DayLog 데이터
    
    // 기존: 전체 경로를 하나의 배열로 반환
    var allCoordinates: [CLLocationCoordinate2D] {
        var coordinates: [CLLocationCoordinate2D] = []
        for section in dayLog.sections {
            for point in section.route {
                let coord = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
                coordinates.append(coord)
            }
        }
        return coordinates
    }
    
    // 수정: 각 섹션별로 좌표 배열을 반환
    var coordinatesBySection: [[CLLocationCoordinate2D]] {
        return dayLog.sections.map { section in
            section.route.map {
                CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
            }
        }
    }
    
    // MARK: - Input & Output
    enum Input {
        case menuSelected(String)
    }
    
    enum Output {
        case edit
        case share
        case delete
    }
    
    let input = PassthroughSubject<Input, Never>()
    let output = CurrentValueSubject<Output?, Never>(nil)
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(dayLog: DayLog) {
        self.dayLog = dayLog
        bind()
    }
    
    // MARK: - Bind (Input -> Output)
    private func bind() {
        input
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .menuSelected(let title):
                    switch title {
                    case "수정하기":
                        self.output.send(.edit)
                    case "공유하기":
                        self.output.send(.share)
                    case "삭제하기":
                        self.output.send(.delete)
                    default:
                        break
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - private Functions
}

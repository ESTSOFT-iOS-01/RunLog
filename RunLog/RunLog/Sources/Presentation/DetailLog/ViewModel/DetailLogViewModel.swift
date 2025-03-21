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
        
        // 전체 경로 좌표를 계산하는 computed property
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

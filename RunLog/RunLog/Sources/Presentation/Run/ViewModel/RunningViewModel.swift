//
//  Running.swift
//  RunLog
//
//  Created by 심근웅 on 3/17/25.
//

import UIKit
import Combine
import MapKit

final class RunningViewModel {
    // MARK: - Property
    struct SectionRecord {
        var sectionTime: TimeInterval // 시간
        var distance: Double // 거리
        var steps: Int // 걸음 수
    }
    var record: SectionRecord = SectionRecord(
        sectionTime: 0,
        distance: 0,
        steps: 0
    )
    var timer: Timer?
    // MARK: - Input & Output
    enum Input {
        case runningStart // 운동 시작 -> 시간 업데이트 필요
        // Q) 아마 거리랑 걸음 수도 location처럼 처리를 해야할 듯
        case distanceUpdate(Double) // 거리 업데이트 필요
        case stepsUpdate(Int) // 걸음 수 업데이트 필요
    }
    enum Output {
        case locationUpdate(CLLocation) // 사용자 위치 데이터
        case timerUpdate(String) // 운동 시간 업데이트
        case distanceUpdate // 운동 거리 업데이트
        case stepsUpdate // 운동 걸음 수 업데이트
    }
    let input = PassthroughSubject<Input, Never>()
    let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private let locationManager = LocationManager.shared
    
    // MARK: - Init
    init() {
        bind()
    }
    deinit {
        timer?.invalidate()
        timer = nil
        print("⏹ 운동 종료. 최종 시간: \(record.sectionTime)초")
    }
    
    // MARK: - Bind (Input -> Output)
    private func bind() {
        // 사용자 위치 변경 구독
        locationManager.locationPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] locaiton in
                self?.output.send(.locationUpdate(locaiton))
            }
            .store(in: &cancellables)
        // input에 따라 처리
        self.input
            .receive(on: DispatchQueue.main)
            .sink { [weak self] input in
                guard let self = self else { return }
                switch input {
                case .runningStart:
                    timerUpdate()
                case .distanceUpdate(let distance):
                    print(distance)
                case .stepsUpdate(let steps):
                    print(steps)
                }
            }
            .store(in: &cancellables)
    }
    // 운동 시작하면 초당 운동시간 업데이트
    private func timerUpdate() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.record.sectionTime += 1
            let timeString = self.record.sectionTime.asTimeString
            self.output.send(.timerUpdate(timeString))
        }
    }
}

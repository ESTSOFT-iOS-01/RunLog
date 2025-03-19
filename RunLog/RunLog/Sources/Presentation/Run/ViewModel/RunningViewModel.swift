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
    
    // MARK: - save Datas - 종료 버튼 누르면 저장 될 데이터들
    struct SectionRecord {
        var sectionTime: TimeInterval // 시간
        var distance: Double // 거리
        var steps: Int // 걸음 수
    }
    // 섹션 - 운동 시작 부터 종료 전까지
    var section: Section = Section(
        distance: 0,
        steps: 0,
        route: []
    )
    var record: SectionRecord = SectionRecord(
        sectionTime: 0,
        distance: 0,
        steps: 0
    )
    // MARK: - Property
    var previousCoordinate: CLLocationCoordinate2D?
    var timer: Timer?
    // MARK: - Input & Output
    enum Input {
        case runningStart // 운동 시작 -> 시간 업데이트 필요
        // Q) 아마 거리랑 걸음 수도 location처럼 처리를 해야할 듯
        case distanceUpdate(Double) // 거리 업데이트 필요
    }
    enum Output {
        case locationUpdate(CLLocation) // 사용자 위치 데이터
        case timerUpdate(String) // 운동 시간 업데이트
        case distanceUpdate // 운동 거리 업데이트
        case stepsUpdate(String) // 운동 걸음 수 업데이트
        case lineDraw(MKPolyline) // 지도에 라인을 그림
    }
    let input = PassthroughSubject<Input, Never>()
    let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private let locationManager = LocationManager.shared
    private let pedometerManager = PedometerManager.shared
    
    // MARK: - Init
    init() {
        bind()
    }
    deinit {
        timer?.invalidate()
        timer = nil
        saveLog()
    }
    private func saveLog() {
        print("⏹ 운동 종료 ⏹")
        print("최종 시간: \(record.sectionTime)초") // - section에 담긴 route의 끝에서 처음을 뺀 시간
        print("최종 경로 핀 수: \(section.route.count)")
//        print("최종 경로")
//        for location in section.route {
//            print("경도: \(location.latitude), 위도: \(location.longitude)")
//            print("시간: \(location.timestamp.formattedString(.fullTime))")
//        }
        print("최종 걸음 수: \(section.steps)")
    }
    // MARK: - Bind (Input -> Output)
    private func bind() {
        // 사용자 위치 변경 구독
        locationManager.locationPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                self?.lindDraw(location: location)
            }
            .store(in: &cancellables)
        // 사용자 걸음 수 변경 구독
        pedometerManager.pedometerPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] step in
                // 걸음 수 업데이트
                self?.section.steps = step
                let stepString = "\(step)"
                self?.output.send(.stepsUpdate(stepString))
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
// MARK: - 지도에 그리기
extension RunningViewModel {
    private func lindDraw(location: CLLocation) {
        // 경로 그리기
        if let previousCoordinate = self.previousCoordinate {
            let point1 = CLLocationCoordinate2DMake(
                previousCoordinate.latitude,
                previousCoordinate.longitude
            )
            let point2 = CLLocationCoordinate2DMake(
                location.coordinate.latitude,
                location.coordinate.longitude
            )
            let points: [CLLocationCoordinate2D] = [point1, point2]
            let lineDraw = MKPolyline(coordinates: points, count: points.count)
            self.output.send(.lineDraw(lineDraw))
        }
        self.previousCoordinate = location.coordinate
        // 위치 변경
        let point: Point = Point(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            timestamp: Date())
        self.section.route.append(point)
        self.output.send(.locationUpdate(location))
    }
}

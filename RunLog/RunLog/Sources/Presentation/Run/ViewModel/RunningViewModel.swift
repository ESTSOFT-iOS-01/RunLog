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
    // MARK: - 운동 시작 부터 종료 전까지의 정보
    // +) save 기능 넣으면 private으로 변경
    var section: Section = Section(
        distance: 0,
        steps: 0,
        route: []
    )
    private var timeRecord: TimeInterval = 0
    // MARK: - Input & Output
    enum Input {
        case runningStart // 운동 시작 -> 시간 업데이트 필요
        case runningStop // 운동 종료 -> 결과 저장
    }
    enum Output {
        case locationUpdate(CLLocation) // 사용자 위치 데이터
        case timerUpdate(String) // 운동 시간 업데이트
        case distanceUpdate(String) // 운동 거리 업데이트
        case stepsUpdate(String) // 운동 걸음 수 업데이트
        case lineDraw(MKPolyline) // 지도에 라인을 그림
    }
    let input = PassthroughSubject<Input, Never>()
    let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    // MARK: - Property
    private let locationManager = LocationManager.shared
    private let pedometerManager = PedometerManager.shared
    private let distanceManager = DistanceManager.shared
    private var timer: Timer?
    
    // MARK: - Init
    init() {
        bind()
    }
    // viewController에도 동일 함수 존재 - 실제 저장할 때는 여기서 작동(Controller는 실기기에서 확인용 alert띄우기용)
    private func saveLog() {
        guard let startTime = section.route.first?.timestamp,
              let endTime = section.route.last?.timestamp
        else {
            print("루트가 없음")
            return
        }
        let totalTime = endTime.timeIntervalSince(startTime)
        let message: String =
        """
        ⏹ 운동 종료 ⏹
        시작 시간: \(startTime.formattedString(.fullTime))초
        종료 시간: \(endTime.formattedString(.fullTime))초
        총 운동 시간: \(totalTime)초
        최종 경로 핀 수: \(section.route.count)
        최종 걸음 수: \(section.steps)
        """
        print(message)
        print("최종 경로")
        for location in section.route {
            print("경도: \(location.latitude), 위도: \(location.longitude)")
            print("시간: \(location.timestamp.formattedString(.fullTime))")
        }
    }
    // MARK: - Bind (Input -> Output)
    private func bind() {
        // 사용자 위치 변경 구독
        locationManager.locationPublisher
            .sink { [weak self] location in
                guard let self = self else { return }
                if let last = self.section.route.last {
                    let previous = CLLocation(
                        latitude: last.latitude,
                        longitude: last.longitude
                    )
                    // 이전 위치가 있으면 이동 거리를 요청
                    self.distanceManager.input.send(.requestDistance(location, previous))
                    // 이전 위치가 있으면 라인을 그림
                    self.lindDraw(location: location, previous: previous)
                }
                // 현재 위치를 저장
                let current: Point = Point(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude,
                    timestamp: Date())
                self.section.route.append(current)
                // 이전 위치와 상관없이 현위치로 이동
                self.output.send(.locationUpdate(location))
            }
            .store(in: &cancellables)
        // 사용자 걸음 수 변경 구독
        pedometerManager.pedometerPublisher
            .sink { [weak self] step in
                guard let self = self else { return }
                // 걸음 수 업데이트
                self.section.steps = step
                let stepString = "\(step)"
                self.output.send(.stepsUpdate(stepString))
            }
            .store(in: &cancellables)
        // input에 따라 처리
        self.input
            .sink { [weak self] input in
                guard let self = self else { return }
                switch input {
                case .runningStart:
                    runningStart()
                case .runningStop:
                    runnungStop()
                }
            }
            .store(in: &cancellables)
        // 사용자 이동 거리 변경 구독
        distanceManager.output
            .sink { [weak self] output in
                guard let self = self else { return }
                switch output {
                case .responseDistance(let distance):
                    self.section.distance += distance
                    // 거리에 따라 단위 변경
                    let distanceString = "\((self.section.distance / 1000).toString(withDecimal: 2))km"
                    self.output.send(.distanceUpdate(distanceString))
                }
            }
            .store(in: &cancellables)
    }
    // 운동 시작
    private func runningStart() {
        // 시작 위치를 경로에 저장
        let currentLocation = locationManager.currentLocation
        let point: Point = Point(
            latitude: currentLocation.coordinate.latitude,
            longitude: currentLocation.coordinate.longitude,
            timestamp: Date())
        self.section.route.append(point)
        // 타이머 시작
        self.timerUpdate()
    }
    // 운동 종료
    private func runnungStop() {
        // 타이머 종료
        self.timer?.invalidate()
        self.timer = nil
        // 마지막 위치를 경로에 저장
        let currentLocation = locationManager.currentLocation
        let point: Point = Point(
            latitude: currentLocation.coordinate.latitude,
            longitude: currentLocation.coordinate.longitude,
            timestamp: Date())
        self.section.route.append(point)
        // 내용 저장
        self.saveLog()
    }
    // 운동 종료
    // 운동 시작하면 초당 운동시간 업데이트
    private func timerUpdate() {
        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ) { [weak self] _ in
            guard let self = self else { return }
            self.timeRecord += 1
            let timeString = timeRecord.asTimeString
            self.output.send(.timerUpdate(timeString))
        }
    }
}
// MARK: - 지도에 그리기
extension RunningViewModel {
    private func lindDraw(location: CLLocation, previous: CLLocation) {
        let point1 = CLLocationCoordinate2DMake(
            previous.coordinate.latitude,
            previous.coordinate.longitude
        )
        let point2 = CLLocationCoordinate2DMake(
            location.coordinate.latitude,
            location.coordinate.longitude
        )
        let points: [CLLocationCoordinate2D] = [point1, point2]
        let lineDraw = MKPolyline(coordinates: points, count: points.count)
        self.output.send(.lineDraw(lineDraw))
    }
}

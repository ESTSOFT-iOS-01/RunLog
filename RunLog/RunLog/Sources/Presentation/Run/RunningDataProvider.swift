//
//  RunningDataProvider.swift
//  RunLog
//
//  Created by 심근웅 on 3/21/25.
//

import Foundation
import MapKit
import Combine

// MARK: - 운동 정보에 대한 각종 정보를 가지고 있고 전달해주는 객체
final class RunningDataProvider {
//    // Syr) 테스트용 Start
//    let dummy = SyrDummyTest()
//    // Syr) 테스트용 End
    
    // MARK: - Singleton
    static let shared = RunningDataProvider()
    private init() {
        bind()
    }
    
    // MARK: - Input
    enum Input {
        // Main Request
        case requestRunningStart // 러닝 시작: DayLog생성 / 섹션생성 및 기록
        case requestRunningStop // 러닝 종료: 섹션 기록 저장
        
        // RunHome Request - 대부분 단편 정보
        case requestCurrentLocation // 현재 위치를 요청
        case requestCurrentCityName // 도시이름(String) 요청
        case requestCurrentWeather // 날씨 + 대기질 정보 요청
        
        case requestSaveImage // 데이 로그 이미지 저장
    }
    let input = PassthroughSubject<Input, Never>()
    
    // MARK: - Output
    enum RunHomeOutput {
        case responseRunningStart
        case responseCurrentLocation(CLLocation) // 현재위치(CLLocatio)를 제공
        case responseCurrentCityName(String) // 도시이름(String)을 제공
        case responseCurrentWeather((Int, Double), Int) // 날씨+대기질(String)을 제공
    }
    let runHomeOutput = PassthroughSubject<RunHomeOutput, Never>()
    
    enum RunningOutput {
        case responseRunningStop
        case responseCurrentLocation(CLLocation) // 현재위치(CLLocatio)를 제공
        case responseCurrentTimes(TimeInterval) // 총 운동시간(TimeInterval) 제공
        case responseCurrentDistances(Double) // 총 운동거리(Double) 제공
        case responseCurrentSteps(Int) // 총 걸음수(Int) 제공
        case responseLineDraw(MKPolyline) // 이동 경로(MKPolyline)를 제공
    }
    let runningOutput = PassthroughSubject<RunningOutput, Never>()
    
    
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private var section: Section = Section(distance: 0, steps: 0, route: [])
    private var previousLocation: CLLocation? // 이전 위치
    private var currentLocation: CLLocation?
    private var previousCity: String? // 이전 도시
    private var currentCity: String?
    private var currentWeather: Int?
    private var currentTemperature: Double?
    private var currentTimer: Timer? // 운동 시간 측정 타이머
    private var currentRecordTime: TimeInterval = 0 // 총 운동 시간
    private var currentIsRunning: Bool = false // 운동 상태
   
    // MARK: - Manager
    private let locationManger = LocationManager.shared
    private let pedometerManager = PedometerManager.shared
    private let distanceManager = DistanceManager.shared
    private let drawingManager = DrawingManager.shared
    
    // MARK: - Service
    private let weatherService = OpenWeatherService.shared
    
    // MARK: - Usecase
    @Dependency private var dayLogUseCase: DayLogUseCase
}

// MARK: - Binding
extension RunningDataProvider {
    private func bind() {
        // MARK: -  Input 처리
        self.input
            .sink { [weak self] input in
                guard let self = self else { return }
                switch input {
                // MARK: - Main Request
                case .requestRunningStart:
                    self.requestRunningStart()
                case .requestRunningStop:
                    self.requestRunningStop()
                    
                // MARK: - RunHome Request
                case .requestCurrentLocation:
                    locationManger.input.send(.requestCurrentLocation)
                case .requestCurrentCityName:
                    guard let location = self.currentLocation else { return }
                    locationManger.input.send(.requestCityName(location))
                case .requestCurrentWeather:
                    guard let location = self.currentLocation else { return }
                    self.weatherService.input.send(.requestWeather(location))
                default:
                    print("사진 저장 요청")
                }
            }
            .store(in: &cancellables)
        
        // MARK: - Locaiton Manager
        locationManger.output
            .sink { [weak self] output in
                guard let self = self else { return }
                switch output {
                case .locationUpdate(let location):
                    self.locationUpdate(location: location)
                case .responseCityName(let placemark):
                    let name = placemark.placemarksToString()
                    self.currentCity = name
                    self.runHomeOutput.send(.responseCurrentCityName(name))
                    // 이전과 다른 지역이면 날씨를 받아옴
                    if name != previousCity {
                        self.input.send(.requestCurrentWeather)
                    }
                    previousCity = name
                }
            }
            .store(in: &cancellables)
        
        // MARK: - Distance Manager
        distanceManager.output
            .sink { [weak self] output in
                guard let self = self else { return }
                switch output {
                case .responseDistance(let distance):
                    self.section.distance += (distance / 1000)
                    let distances = self.section.distance
                    self.runningOutput.send(.responseCurrentDistances(distances))
                }
            }
            .store(in: &cancellables)
        
        // MARK: - Pedometer Manager
        pedometerManager.output
            .sink { [weak self] output in
                guard let self = self else { return }
                switch output {
                case .responseSteps(let step):
                    self.section.steps = step
                    let steps = self.section.steps
                    self.runningOutput.send(.responseCurrentSteps(steps))
                }
            }
            .store(in: &cancellables)
        
       // MARK: - OpenWeather Service
        weatherService.output
            .sink { [weak self] output in
                guard let self = self else { return }
                switch output {
                case .responseWeather(let weather, let aqi):
                    self.currentWeather = weather.0
                    self.currentTemperature = weather.1
                    self.runHomeOutput.send(.responseCurrentWeather(weather, aqi))
                }
            }
            .store(in: &cancellables)
        
        // MARK: - Drawing Manager
        drawingManager.output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                guard let self = self else { return }
                switch output {
                case .responsePolyline(let polyline):
                    self.runningOutput.send(.responseLineDraw(polyline))
                case .responseFullRoutePolyline(let mapView):
                    // 사진을 만드는 매니저? 랜더러?에 해당 맵뷰를 send
                    print("")
                }
            }
            .store(in: &cancellables)
    }
    
    // 위치 업데이트
    private func locationUpdate(location: CLLocation) {
        self.previousLocation = self.currentLocation
        self.currentLocation = location
        self.input.send(.requestCurrentCityName)
        // 운동인지에 따라 분기 처리
        if self.currentIsRunning {
            guard let previous = self.previousLocation,
                  let current = self.currentLocation
            else { return }
            let point = Point(
                latitude: current.coordinate.latitude,
                longitude: current.coordinate.longitude,
                timestamp: Date()
            )
            self.section.route.append(point)
            self.runningOutput.send(.responseCurrentLocation(current))
            drawingManager.input.send(.requestLine(previous, current))
            distanceManager.input.send(.requestDistance(
                previous: previous,
                current: current)
            )
        }
        else {
            self.runHomeOutput.send(.responseCurrentLocation(location))
        }
    }
}

// MARK: - 러닝 시작
extension RunningDataProvider {
    private func requestRunningStart() {
//        // Syr) 테스트용 Start
//        dummy.startDummySet()
//        // Syr) 테스트용 End
        
        // 데이로그 생성
        Task {
            guard let locationName = self.currentCity,
                  let weather = self.currentWeather,
                  let temperature = self.currentTemperature
            else { return }
            try await dayLogUseCase.initializeDayLog(
                locationName: locationName,
                weather: weather,
                temperature: temperature
            )
        }
        
        // 섹션 생성
        self.section = Section(distance: 0, steps: 0, route: [])
        
        // 운동 시작 위치를 경로에 저장
        guard let startLocation = self.currentLocation else { return }
        let startPoint: Point = Point(
            latitude: startLocation.coordinate.latitude,
            longitude: startLocation.coordinate.longitude,
            timestamp: Date()
        )
        self.section.route.append(startPoint)
        
        // 운동O 상태로 변경
        currentIsRunning = true
        
        // 운동 시간 측정 시작
        runningTimerStart()
        
        // 운동 걸음수 측정 시작
        pedometerManager.input.send(.requestPedometerStart)
        
        // 정상적인으로 운동 시작
        self.runHomeOutput.send(.responseRunningStart)
    }
    
    // 운동 시간 측정 시작
    private func runningTimerStart() {
        self.currentRecordTime = 0
        self.currentTimer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ) { [weak self] _ in
            guard let self = self else { return }
            self.currentRecordTime += 1
            let time = self.currentRecordTime
            self.runningOutput.send(.responseCurrentTimes(time))
        }
    }
}

// MARK: - 러닝 종료
extension RunningDataProvider {
    private func requestRunningStop() {
//        // Syr) 테스트용 Start
//        dummy.stopDummySet()
//        // Syr) 테스트용 End
        
        // 운동 종료 위치를 경로에 저장
        guard let endLocation = self.currentLocation else { return }
        let endPoint: Point = Point(
            latitude: endLocation.coordinate.latitude,
            longitude: endLocation.coordinate.longitude,
            timestamp: Date()
        )
        self.section.route.append(endPoint)
        
        // 운동걸음수 측정 종료
        pedometerManager.input.send(.requestPedometerStop)
        
        // 운동시간 측정 종료
        runningTimerStop()
        
        // 운동X 상태로 변경
        currentIsRunning = false
        
        //+) 여기서 현재까지의 데이로그를 기반으로 전체 폴리라인을 요청을 보냄
        // -> 요청에 대한 답은 drawingManager.output에서 확인
        Task {
            // 데이로그에 섹션 저장
            try await dayLogUseCase.addSectionByDate(Date(), section: self.section)
            
            if let dayLog = try await dayLogUseCase.getDayLogByDate(Date()) {
                var allPoint: [CLLocation] = []
                for section in dayLog.sections {
                    for route in section.route {
                        let location = CLLocation(
                            latitude: route.latitude,
                            longitude: route.longitude
                        )
                        allPoint.append(location)
                    }
                }
                print("현재까지 데이로그의 경로 포인트 수 : \(allPoint.count)")
                await self.drawingManager.input.send(.requestFullRoutePolyline(allPoint))
            }
        }
        
        // 정상적인 운동 종료
        self.runningOutput.send(.responseRunningStop)
        
        // +) 아래는 운동 정보 로그 찍어보기
        guard let startTime = section.route.first?.timestamp,
              let endTime = section.route.last?.timestamp
        else {
            print("루트 없음")
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
        
    }
    
    // 운동 시간 측정 종료
    private func runningTimerStop() {
        self.currentTimer?.invalidate()
        self.currentTimer = nil
    }
}

// MARK: - 테스트 더미 본체
// Syr) 테스트용 Start
final class SyrDummyTest {
    var timer: Timer?
    var dummyRoutes: [CLLocation] = []
    var routeIndex = 0
    let locationManger = CLLocationManager()
    
    func startDummySet() {
        guard let currentLocation = locationManger.location else { return }
        
        dummyRoutes = createRoute(from: currentLocation) // 더미 경로 생성
        routeIndex = 0
        
        // 3초 후 시작 (async/await에서의 첫 sleep 대체)
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
            self.startSendingDummyRoutes()
        }
    }
    
    func startSendingDummyRoutes() {
        timer?.invalidate() // 기존 타이머 종료 (중복 실행 방지)
        
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] _ in
            guard let self = self, self.routeIndex < self.dummyRoutes.count else {
                self?.timer?.invalidate() // 모든 경로 전송 완료 시 타이머 정지
                return
            }
            
            let route = self.dummyRoutes[self.routeIndex]
            LocationManager.shared.output.send(.locationUpdate(route)) // 위치 업데이트 전송
            self.routeIndex += 1
        }
    }
    
    func stopDummySet() {
        timer?.invalidate() // 타이머 정지
        timer = nil
    }
    func createRoute(from location: CLLocation) -> [CLLocation] {
        let center = location.coordinate // 현재 위치를 중심으로 설정
        let radius: Double = 0.00135 // 150m 반경 (위도/경도 변환값)
        let totalPoints = 10 // 50개 좌표
        
        var locations: [CLLocation] = []
        
        for i in 0..<totalPoints {
            let angle = Double(i) / Double(totalPoints) * 2 * .pi // 0 ~ 2π (360도)
            let latOffset = radius * cos(angle) // 위도 변동
            let lonOffset = radius * sin(angle) // 경도 변동
            
            let newLat = center.latitude + latOffset
            let newLon = center.longitude + lonOffset
            
            locations.append(CLLocation(latitude: newLat, longitude: newLon))
        }
        locations.append(locations.first!) // 원을 닫기 위해 첫 번째 좌표 추가
        
        return locations
    }
}
// Syr) 테스트용 End

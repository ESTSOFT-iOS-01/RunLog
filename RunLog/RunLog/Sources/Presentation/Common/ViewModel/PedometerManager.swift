//
//  PedometerManager.swift
//  RunLog
//
//  Created by 심근웅 on 3/19/25.
//

import Foundation
import Combine
import CoreMotion

final class PedometerManager {
//    // MARK: - Dummy
//    private var dummyStepCount = 0
//    private var timer: Timer?
//    func startDummyPedometerUpdates() {
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
//            guard let self = self else { return }
//            self.dummyStepCount += Int.random(in: 1...3) // ✅ 1~3 걸음씩 증가
//            self.pedometerSubject.send(self.dummyStepCount)
//        }
//    }
//    // MARK: - 더미 걸음 수 업데이트 중지
//    func stopDummyPedometerUpdates() {
//        timer?.invalidate()
//        timer = nil
//        dummyStepCount = 0
////        print("🛑 더미 걸음 수 측정 중지")
//    }
    
    // MARK: - Singleton
    static let shared = PedometerManager()
    // MARK: - Propertise
    private let pedometer = CMPedometer()
//    private let pedometerSubject = PassthroughSubject<Int, Never>()
    let pedometerSubject = PassthroughSubject<Int, Never>() // test코드
    var pedometerPublisher: AnyPublisher<Int, Never> {
        pedometerSubject.eraseToAnyPublisher()
    }
    // MARK: - Init
    private init() { }
    
    func startPedometerUpdate() {
        guard CMPedometer.isStepCountingAvailable() else {
            print("측정 불가 기기")
            return
        }
        pedometer.startUpdates(from: Date()) { [weak self] data, error in
            guard let self = self, let data = data, error == nil else { return }
            let stepCount = data.numberOfSteps.intValue
            self.pedometerSubject.send(stepCount)
        }
    }
    func stopPedometerUpdate() {
        pedometer.stopUpdates()
        print("걸음 수 측정 중지")
    }
}

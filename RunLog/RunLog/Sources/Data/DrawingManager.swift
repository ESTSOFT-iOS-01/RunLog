//
//  DrawingManager.swift
//  RunLog
//
//  Created by 심근웅 on 3/22/25.
//

import Foundation
import MapKit
import Combine

final class DrawingManager {
    
    // MARK: - Singleton
    static let shared = DrawingManager()
    private init() {
        bind()
    }
    
    // MARK: - Input
    enum Input {
        case requestLine(CLLocation, CLLocation) // 단일 경로 - 운동중 화면
        case requestLines([CLLocation]) // 전체 경로 - 섹션 종료 후 사진 새로 만들때
    }
    let input = PassthroughSubject<Input, Never>()
    
    // MARK: - Output
    enum Output {
        case responsePolyline(MKPolyline)
        case responsePolylines(MKPolyline)
    }
    let output = PassthroughSubject<Output, Never>()
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private var mapView: MKMapView?
    
    
    // MARK: - Bind (Input -> Output)
    private func bind() {
        self.input
            .sink { [weak self] input in
                guard let self = self else { return }
                switch input {
                case .requestLine(let start, let end):
                    let polyline = self.createPolyline(start,end)
                    self.output.send(.responsePolyline(polyline))
                case .requestLines(let route):
                    let polyline = createPolylines(route)
                    self.output.send(.responsePolylines(polyline))
                }
            }
            .store(in: &cancellables)
    }
    
    // 단일 폴리라인 생성
    private func createPolyline(_ start: CLLocation, _ end: CLLocation) -> MKPolyline {
        let coordinates = [start.coordinate, end.coordinate]
        return MKPolyline(coordinates: coordinates, count: coordinates.count)
    }
    
    // 전체 폴리라인 생성
    private func createPolylines(_ route: [CLLocation]) -> MKPolyline {
        let route = route.map { $0.coordinate }
        return MKPolyline(coordinates: route, count: route.count)
    }
}

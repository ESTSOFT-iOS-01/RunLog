//
//  DrawingManager.swift
//  RunLog
//
//  Created by 심근웅 on 3/22/25.
//

import Foundation
import MapKit
import Combine

final class DrawingManager: NSObject, MKMapViewDelegate {
    
    // MARK: - Singleton
    static let shared = DrawingManager()
    private override init() {
        super.init()
        bind()
    }
    
    // MARK: - Input
    enum Input {
        case requestLine(CLLocation, CLLocation) // 단일 경로 - 운동중 화면
        case requestFullRoutePolyline([CLLocation]) // 전체 경로 - 섹션 종료 후 사진 새로 만들때
    }
    let input = PassthroughSubject<Input, Never>()
    
    // MARK: - Output
    enum Output {
        case responsePolyline(MKPolyline)
        case responseFullRoutePolyline(MKMapView)
    }
    let output = PassthroughSubject<Output, Never>()
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Bind (Input -> Output)
    private func bind() {
        self.input
            .receive(on: DispatchQueue.main)
            .sink { [weak self] input in
                guard let self = self else { return }
                switch input {
                case .requestLine(let start, let end):
                    let polyline = self.createPolyline(start,end)
                    self.output.send(.responsePolyline(polyline))
                case .requestFullRoutePolyline(let route):
                    let mapView = MKMapView()
                    mapView.delegate = self
                    let polyline = createFullRoutePolylines(route)
                    mapView.addOverlay(polyline)
                    self.output.send(.responseFullRoutePolyline(mapView))
                    mapView.delegate = nil
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - 단일 폴리라인 생성
    private func createPolyline(_ start: CLLocation, _ end: CLLocation) -> MKPolyline {
        let coordinates = [start.coordinate, end.coordinate]
        return MKPolyline(coordinates: coordinates, count: coordinates.count)
    }
    
    // MARK: - 전체 폴리라인 생성
    private func createFullRoutePolylines(_ route: [CLLocation]) -> MKPolyline {
        let route = route.map { $0.coordinate }
        return MKPolyline(coordinates: route, count: route.count)
    }
    
    // MARK: - 폴리라인 스타일 적용
    func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .systemBlue // 폴리라인 색상
        renderer.lineWidth = 4.0           // 폴리라인 두께

        return renderer
    }
}

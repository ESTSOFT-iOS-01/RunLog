import CoreLocation

struct DummyLocation {
    static let route: [CLLocation] = {
        let center = CLLocationCoordinate2D(latitude: 37.554722, longitude: 126.970833) // 원의 중심 (서울역 근처)
        let radius: Double = 0.00135 // 150m (위도/경도 변환값)
        let totalPoints = 50 // 100개 좌표
        
        var locations: [CLLocation] = []
        
        for i in 0..<totalPoints {
            let angle = Double(i) / Double(totalPoints) * 2 * .pi // 0 ~ 2π (360도)
            let latOffset = radius * cos(angle) // 원 형태의 위도 변동
            let lonOffset = radius * sin(angle) // 원 형태의 경도 변동
            
            let newLat = center.latitude + latOffset
            let newLon = center.longitude + lonOffset
            
            locations.append(CLLocation(latitude: newLat, longitude: newLon))
        }
        locations.append(locations.first!)
        return locations
    }()
    
    
    
    static func distanceCheck() {
        let preLocation = LocationManager.shared.currentLocation
        // 거리 변환값 (각 거리(m)를 위도/경도 값으로 변환)
        let metersToLatitude = 1.0 / 111_000.0 // 위도 기준 1m당 변환값
        let metersToLongitude = 1.0 / 88_000.0  // 서울 기준 경도 1m당 변환값
        
        // 새로운 위치들 계산
        let currentLocation100m = CLLocation(
            latitude: preLocation.coordinate.latitude + (100 * metersToLatitude),
            longitude: preLocation.coordinate.longitude + (100 * metersToLongitude)
        )
        
        let currentLocation540m = CLLocation(
            latitude: preLocation.coordinate.latitude + (540 * metersToLatitude),
            longitude: preLocation.coordinate.longitude + (540 * metersToLongitude)
        )
        
        let currentLocation2400m = CLLocation(
            latitude: preLocation.coordinate.latitude + (2400 * metersToLatitude),
            longitude: preLocation.coordinate.longitude + (2400 * metersToLongitude)
        )
        DistanceManager.shared.input.send(.requestDistance(currentLocation2400m, preLocation))
    }
    
    static func lineCheck() {
        for (index, rou) in self.route.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 2) {
                LocationManager.shared.setDummy(location: rou)
            }
        }
    }
}

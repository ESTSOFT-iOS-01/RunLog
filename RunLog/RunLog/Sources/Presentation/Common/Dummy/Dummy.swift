import CoreLocation

struct DummyLocation {
    static let route: [CLLocation] = {
        let center = CLLocationCoordinate2D(latitude: 37.554722, longitude: 126.970833) // 원의 중심 (서울역 근처)
        let radius: Double = 0.00135 // 150m (위도/경도 변환값)
        let totalPoints = 20 // 100개 좌표
        
        var locations: [CLLocation] = []
        
        for i in 0..<totalPoints {
            let angle = Double(i) / Double(totalPoints) * 2 * .pi // 0 ~ 2π (360도)
            let latOffset = radius * cos(angle) // 원 형태의 위도 변동
            let lonOffset = radius * sin(angle) // 원 형태의 경도 변동
            
            let newLat = center.latitude + latOffset
            let newLon = center.longitude + lonOffset
            
            locations.append(CLLocation(latitude: newLat, longitude: newLon))
        }
        
        return locations
    }()
}

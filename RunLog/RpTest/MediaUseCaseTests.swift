import XCTest
import MapKit
@testable import RunLog

final class MediaUseCaseTests: XCTestCase {
    
    var mapView: MKMapView!
    var mediaUseCase: MediaUseCaseImpl!
    
    override func setUpWithError() throws {
        super.setUp()
        mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        mediaUseCase = MediaUseCaseImpl() // 실제 클래스에 맞게 초기화
    }

    override func tearDownWithError() throws {
        mapView = nil
        mediaUseCase = nil
        super.tearDown()
    }

    func test_createAndSavePolylineImage() async throws {
        // 1. 폴리라인 데이터 준비
        let points: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            CLLocationCoordinate2D(latitude: 37.7750, longitude: -122.4180)
        ]
        
        let polyline = MKPolyline(coordinates: points, count: points.count)
        
        // 2. 폴리라인을 맵에 추가
        mapView.addOverlay(polyline)
        
        // 3. 폴리라인 이미지 생성
        let image = try await mediaUseCase.createPolylineImage(mapView: mapView, overlays: mapView.overlays)
        
        // 4. 이미지 저장
        let filePath = try saveImageToDocuments(image: image, imageName: "polyline_image.png")
        
        // 5. 이미지 파일이 실제로 존재하는지 확인
        let fileManager = FileManager.default
        XCTAssertTrue(fileManager.fileExists(atPath: filePath), "이미지 파일이 존재하지 않습니다.")
        
        // 6. 이미지 크기 확인
        if let savedImage = UIImage(contentsOfFile: filePath) {
            let expectedWidth = mapView.bounds.size.width * UIScreen.main.scale
            let expectedHeight = mapView.bounds.size.height * UIScreen.main.scale
            XCTAssertEqual(savedImage.size.width, expectedWidth, "이미지의 가로 크기가 예상과 다릅니다.")
            XCTAssertEqual(savedImage.size.height, expectedHeight, "이미지의 세로 크기가 예상과 다릅니다.")
        } else {
            XCTFail("이미지가 제대로 저장되지 않았습니다.")
        }
    }
    
    func saveImageToDocuments(image: UIImage, imageName: String) throws -> String {
        // 1. 도큐먼트 디렉토리 경로 가져오기
        let fileManager = FileManager.default
        let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        // 2. 이미지 파일 경로
        let fileURL = documentDirectory.appendingPathComponent(imageName)
        
        // 3. 이미지 데이터를 PNG로 변환하여 파일로 저장
        guard let imageData = image.pngData() else {
            throw NSError(domain: "com.estsoft.runlog", code: -1, userInfo: [NSLocalizedDescriptionKey: "이미지 변환 실패"])
        }
        
        try imageData.write(to: fileURL)
        
        // 4. 파일 경로 반환
        return fileURL.path
    }
}

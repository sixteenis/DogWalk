//
//  MapIntent.swift
//  DogWalk
//
//  Created by 소정섭 on 11/12/24.
//

import SwiftUI
import MapKit

protocol MapIntentProtocol {
    func startWalk()
    func stopWalk()
    func incrementTimer()
    func showAlert()
    func closeAlert()
    func openAppSettings()
    func setSnapshotOptions(coordinates: [CLLocationCoordinate2D]) -> MKMapSnapshotter.Options
    func getRouteCenterCoordinate(coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D?
    func makeRouteSizeRegion(center: CLLocationCoordinate2D, coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion
    func setRouteImage(route coordinates: [CLLocationCoordinate2D]) async
}

final class MapIntent {
    private weak var state: MapActionProtocol?
    
    init(state: MapActionProtocol? = nil) {
        self.state = state
    }
}

extension MapIntent: MapIntentProtocol {
    func startWalk() {
        print(#function)
        state?.resetCount()
        state?.setTimerOn(true)
        state?.startLocationTracking()
    }
    
    func stopWalk() {
        print(#function)
        state?.setTimerOn(false)
        state?.stopLocationTracking()
    }
    
    func incrementTimer() {
        state?.incrementCount()
    }
    
    func showAlert() {
        state?.setAlert(true)
    }
    
    func closeAlert() {
        state?.setAlert(false)
    }
  
    //설정으로 이동
    func openAppSettings() {
        if let appSettingURL = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(appSettingURL) {
                UIApplication.shared.open(appSettingURL)
            }
        }
    }
  
    //지도 캡처
    func setSnapshotOptions(coordinates: [CLLocationCoordinate2D]) -> MKMapSnapshotter.Options {
        let options = MKMapSnapshotter.Options()
        let filter: MKPointOfInterestFilter = .excludingAll //모든 point of interest가 안보이도록

        //1.경로 중심 좌표 가져오기
        guard let center = getRouteCenterCoordinate(coordinates: coordinates) else { return options }
        //2.경로 전체를 포함하는 region 갱성
        let region = makeRouteSizeRegion(center: center, coordinates: coordinates)
        
        options.pointOfInterestFilter = filter
        options.size = CGSize(width: 400, height: 250)
        options.region = region
        options.scale = UIScreen.main.scale
        
        return options
    }
  
    //경로 좌표 중심값
    func getRouteCenterCoordinate(coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D? {
        guard coordinates.isEmpty == false || coordinates.count >= 1 else { return nil }
        
        var centerLat: CLLocationDegrees = 0
        var centerLon: CLLocationDegrees = 0
        
        for coordinate in coordinates {
            centerLat += coordinate.latitude
            centerLon += coordinate.longitude
        }
        
        centerLat /= Double(coordinates.count)
        centerLon /= Double(coordinates.count)
        
        return CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon)
    }
  
    //최대, 최소 위경도 구해서 MKCoordinateRegion 생성
    func makeRouteSizeRegion(center: CLLocationCoordinate2D, coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
        let minLatitude = coordinates.min(by: { $0.latitude < $1.latitude })?.latitude ?? 0
        let maxLatitude = coordinates.max(by: { $0.latitude < $1.latitude })?.latitude ?? 0
        let minLongitude = coordinates.min(by: { $0.longitude < $1.longitude })?.longitude ?? 0
        let maxLongitude = coordinates.max(by: { $0.longitude < $1.longitude })?.longitude ?? 0
        
        // 경로의 범위 계산
        var latDelta = (maxLatitude - minLatitude) * 2
        var lonDelta = (maxLongitude - minLongitude) * 2
        
        // 최소값 설정 (약 200미터를 의미)
       let minDelta: CLLocationDegrees = 0.002
       latDelta = max(latDelta, minDelta)
       lonDelta = max(lonDelta, minDelta)
        
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        return MKCoordinateRegion(center: center, span: span)
    }
  
    //이미지 가져오기
    func setRouteImage(route coordinates: [CLLocationCoordinate2D]) async {
        guard !coordinates.isEmpty else { return }
        
        let options = setSnapshotOptions(coordinates: coordinates)
        let snapShotter = MKMapSnapshotter(options: options)
        
        return await withCheckedContinuation { continuation in
            snapShotter.start { snapshot, error in
                guard let snapshot = snapshot, error == nil else {
                    continuation.resume()
                    return
                }
                
                let mapImage = snapshot.image
                //지도 이미지에 경로 그리기
                let routeOverlayMapImage = UIGraphicsImageRenderer(size: mapImage.size).image { _ in
                    mapImage.draw(at: .zero)
                    let points = coordinates.map { snapshot.point(for: $0) }
                    let path = UIBezierPath()
                    path.move(to: points.first ?? CGPoint(x: 0, y: 0))
                    
                    for point in points.dropFirst() {
                        path.addLine(to: point)
                    }
                    
                    path.lineWidth = 5
                    UIColor((self.state?.getPolylineColor())!).setStroke()
                    path.stroke()
                }
                //캡처된 이미지를 MapState에 저장
                self.state?.saveCapturedRouteImage(routeOverlayMapImage)
                continuation.resume()
            }
        }
    }
}

//
//  MainMapViewModel.swift
//  WalkTrackerMapbox
//
//  Created by Pavlentiy on 28.01.2022.
//

import MapboxMaps
import CoreLocation

protocol MainMapViewModelProtocol: AnyObject {
    var userPreviousLocations: [Location] { get set }
    
    var userLocation: Box<Location> { get }
    var isCameraMove: Box<Bool> { get }
    
    var sourceIdentifier: String { get }
    var routeLineSource: GeoJSONSource! { get }
    
    func getMapSettings(completion: @escaping(MapInitOptions, CameraLocationConsumer) -> Void)
    func moveCameraToUserLocation()
    func configureLineSource()
    func updateLineSource() -> Feature
}

class MainMapViewModel: MainMapViewModelProtocol {
    let sourceIdentifier = "user-location"
    
    var userPreviousLocations: [Location] = []
    
    var userLocation: Box<Location>
    var isCameraMove: Box<Bool>
    
    var routeLineSource: GeoJSONSource!
    
    // TODO: extract optional
    private var mapLocationConsumer: CameraLocationConsumer!
    
    required init() {
        userLocation = Box(DefaultMapValues.location)
        isCameraMove = Box(false)
        
        mapLocationConsumer = CameraLocationConsumer(userLocation: &userLocation)
    }
    
    func getMapSettings(completion: @escaping(MapInitOptions, CameraLocationConsumer) -> Void) {
        
        let resourceOptions = ResourceOptions(accessToken: "pk.eyJ1IjoidXBhZmZ5IiwiYSI6ImNreXI4aHpuajByNHcydm12OXl0bjg3eHoifQ.Wetj_ajp8TRY_Z9vA8HLJA")
        let mapInitOptions = MapInitOptions(resourceOptions: resourceOptions, styleURI: .dark)
        
        completion(mapInitOptions, mapLocationConsumer)
    }
    
    @objc func moveCameraToUserLocation() {
        isCameraMove.value = true
    }
    
    func configureLineSource() {
        routeLineSource = GeoJSONSource()
        routeLineSource.data = .feature(Feature(geometry: .lineString(LineString([]))))
        
        userPreviousLocations.append(userLocation.value)
    }
    
    func updateLineSource() -> Feature {
        var coordinates = userPreviousLocations.map { $0.coordinate }
        coordinates.append(userLocation.value.coordinate)
        
        let updatedLine = Feature(geometry: .lineString(LineString(coordinates)))
        routeLineSource.data = .feature(updatedLine)
        
        userPreviousLocations.append(userLocation.value)
        
        return updatedLine
    }
}

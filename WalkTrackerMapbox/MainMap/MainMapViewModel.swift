//
//  MainMapViewModel.swift
//  WalkTrackerMapbox
//
//  Created by Pavlentiy on 28.01.2022.
//

import MapboxMaps
import CoreLocation

protocol MainMapViewModelProtocol: AnyObject {
    
    var userLocation: Box<Location> { get }
    
    func getMapSettings(completion: @escaping(MapInitOptions, CameraLocationConsumer) -> Void)
}

class MainMapViewModel: MainMapViewModelProtocol {
    
    var userLocation: Box<Location>
    
    // TODO: extract optional
    private var mapLocationConsumer: CameraLocationConsumer!
    
    required init() {
        userLocation = Box(DefaultMapValues.location)
        
        mapLocationConsumer = CameraLocationConsumer(userLocation: &userLocation)
    }
    
    func getMapSettings(completion: @escaping(MapInitOptions, CameraLocationConsumer) -> Void) {
        
        let resourceOptions = ResourceOptions(accessToken: "pk.eyJ1IjoidXBhZmZ5IiwiYSI6ImNreXI4aHpuajByNHcydm12OXl0bjg3eHoifQ.Wetj_ajp8TRY_Z9vA8HLJA")
        let mapInitOptions = MapInitOptions(resourceOptions: resourceOptions, styleURI: .light)
        
        completion(mapInitOptions, mapLocationConsumer)
    }
}

//
//  MainMapViewModel.swift
//  WalkTrackerMapbox
//
//  Created by Pavlentiy on 28.01.2022.
//

import MapboxMaps

protocol MainMapViewModelProtocol: AnyObject {
    
    var mapDataDidChange: ((MainMapViewModelProtocol) -> Void)? { get set }
    
    func getMapSettings(completion: @escaping(MapInitOptions, CameraLocationConsumer) -> Void)
}

class MainMapViewModel: MainMapViewModelProtocol {
    var mapLocationConsumer: CameraLocationConsumer!
    var mapDataDidChange: ((MainMapViewModelProtocol) -> Void)?
    
    func getMapSettings(completion: @escaping(MapInitOptions, CameraLocationConsumer) -> Void) {
        
        let resourceOptions = ResourceOptions(accessToken: "pk.eyJ1IjoidXBhZmZ5IiwiYSI6ImNreXI4aHpuajByNHcydm12OXl0bjg3eHoifQ.Wetj_ajp8TRY_Z9vA8HLJA")
        let mapInitOptions = MapInitOptions(resourceOptions: resourceOptions)
        
        mapLocationConsumer = CameraLocationConsumer()
        
        completion(mapInitOptions, mapLocationConsumer)
    }
}

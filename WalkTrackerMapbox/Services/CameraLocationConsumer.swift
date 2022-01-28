//
//  CameraLocationConsumer.swift
//  WalkTrackerMapbox
//
//  Created by Pavlentiy on 28.01.2022.
//

import MapboxMaps

class CameraLocationConsumer: LocationConsumer {
    var userLocation: Box<Location>!
    
    init(userLocation: inout Box<Location>) {
        self.userLocation = userLocation
    }
    
    public func locationUpdate(newLocation: Location) {
        userLocation.value = newLocation
    }
}

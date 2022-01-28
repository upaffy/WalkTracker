//
//  CameraLocationConsumer.swift
//  WalkTrackerMapbox
//
//  Created by Pavlentiy on 28.01.2022.
//

import MapboxMaps

class CameraLocationConsumer: LocationConsumer {
    public func locationUpdate(newLocation: Location) {
        print(newLocation.coordinate)
    }
}

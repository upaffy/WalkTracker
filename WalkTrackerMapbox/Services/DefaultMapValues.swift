//
//  DefaultMapValues.swift
//  WalkTrackerMapbox
//
//  Created by Pavlentiy on 28.01.2022.
//

import MapboxMaps

enum DefaultMapValues {
    static let locationCL = CLLocationCoordinate2D(latitude: 59.956165, longitude: 30.309382)
    static let location = Location(with: CLLocation(latitude: locationCL.latitude, longitude: locationCL.longitude))
}

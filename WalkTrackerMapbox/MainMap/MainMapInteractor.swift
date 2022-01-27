//
//  MainMapInteractor.swift
//  WalkTrackerMapbox
//
//  Created by Pavlentiy on 25.01.2022.
//

import MapboxMaps

protocol MainMapInteractorInputProtocol {
    init(presenter: MainMapInteractorOutputProtocol)
    func provideMainMapData()
    func provideConsumerData()
}

protocol MainMapInteractorOutputProtocol: AnyObject {
    func receiveMainMapData(mainMapData: MainMapData)
    func receiveMainMapConsumer(mainMapConsumer: MainMapConsumer)
}

class MainMapInteractor: MainMapInteractorInputProtocol {
    unowned var presenter: MainMapInteractorOutputProtocol
    
    required init(presenter: MainMapInteractorOutputProtocol) {
        self.presenter = presenter
    }
    
    func provideMainMapData() {
        
        // MARK: - Map options
        let resourceOptions = ResourceOptions(
            accessToken: "pk.eyJ1IjoidXBhZmZ5IiwiYSI6ImNreXI4aHpuajByNHcydm12OXl0bjg3eHoifQ.Wetj_ajp8TRY_Z9vA8HLJA"
        )
        let mapInitOptions = MapInitOptions(resourceOptions: resourceOptions)

        let mainMapData = MainMapData(mapInitOptions: mapInitOptions)
        
        presenter.receiveMainMapData(mainMapData: mainMapData)
    }
    
    @objc func provideConsumerData() {
        // MARK: - Map consumer
        let mapLocationConsumer = CameraLocationConsumer()
        let mainMapConsumer = MainMapConsumer(mapLocationConsumer: mapLocationConsumer)
        
        presenter.receiveMainMapConsumer(mainMapConsumer: mainMapConsumer)
    }
}

// MARK: - Location
class CameraLocationConsumer: LocationConsumer {
    public func locationUpdate(newLocation: Location) {
        print(newLocation.coordinate)
    }
}

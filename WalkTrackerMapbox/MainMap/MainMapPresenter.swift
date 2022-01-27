//
//  MainMapPresenter.swift
//  WalkTrackerMapbox
//
//  Created by Pavlentiy on 25.01.2022.
//
import MapboxMaps

struct MainMapData {
    let mapInitOptions: MapInitOptions
}

struct MainMapConsumer {
    let mapLocationConsumer: CameraLocationConsumer
}

class MainMapPresenter: MainMapViewOutputProtocol, MainMapInteractorOutputProtocol {
    
    unowned var view: MainMapViewInputProtocol!
    var interactor: MainMapInteractorInputProtocol!
    
    required init(view: MainMapViewInputProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        interactor.provideMainMapData()
    }
    
    func mapDidLoad() {
        interactor.provideConsumerData()
    }
    
    func receiveMainMapData(mainMapData: MainMapData) {
        view.initMap(mapInitOptions: mainMapData.mapInitOptions)
    }
    
    func receiveMainMapConsumer(mainMapConsumer: MainMapConsumer) {
        view.connectMapViewWith(consumer: mainMapConsumer.mapLocationConsumer)
    }
}

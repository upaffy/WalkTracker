//
//  MainMapPresenter.swift
//  WalkTrackerMapbox
//
//  Created by Pavlentiy on 25.01.2022.
//
import MapboxMaps

struct MainMapData {
    let mapInitOptions: MapInitOptions
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
    
    func receiveMainMapData(mainMapData: MainMapData) {
        view.initMap(
            mapInitOptions: mainMapData.mapInitOptions,
            consumer: mainMapData.mapLocationConsumer
        )
    }
}

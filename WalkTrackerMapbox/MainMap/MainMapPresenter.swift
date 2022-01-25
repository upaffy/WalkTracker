//
//  MainMapPresenter.swift
//  WalkTrackerMapbox
//
//  Created by Pavlentiy on 25.01.2022.
//

struct MainMapData {
    let greting: String
    let object: String
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
        view.setGreeting(greeting: "\(mainMapData.greting) \(mainMapData.object)")
    }
}

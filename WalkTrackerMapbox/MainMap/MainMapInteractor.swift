//
//  MainMapInteractor.swift
//  WalkTrackerMapbox
//
//  Created by Pavlentiy on 25.01.2022.
//

import Foundation

protocol MainMapInteractorInputProtocol {
    init(presenter: MainMapInteractorOutputProtocol)
    func provideMainMapData()
}

protocol MainMapInteractorOutputProtocol: AnyObject {
    func receiveMainMapData(mainMapData: MainMapData)
}

class MainMapInteractor: MainMapInteractorInputProtocol {
    unowned var presenter: MainMapInteractorOutputProtocol
    
    required init(presenter: MainMapInteractorOutputProtocol) {
        self.presenter = presenter
    }
    
    func provideMainMapData() {
        let greeting = Greeting(greeting: "Hello", object: "World")
        let greetingData = MainMapData(greting: greeting.greeting, object: greeting.object)
        
        presenter.receiveMainMapData(mainMapData: greetingData)
    }
}

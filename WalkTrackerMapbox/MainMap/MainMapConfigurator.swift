//
//  MainMapConfigurator.swift
//  WalkTrackerMapbox
//
//  Created by Pavlentiy on 25.01.2022.
//

protocol MainMapConfiguratorInputProtocol {
    func configure(withView view: MainMapViewController)
}

class MainMapConfigurator: MainMapConfiguratorInputProtocol {
    
    func configure(withView view: MainMapViewController) {
        let presenter = MainMapPresenter(view: view)
        let interactor = MainMapInteractor(presenter: presenter)
        
        view.presenter = presenter
        presenter.interactor = interactor
    }
}

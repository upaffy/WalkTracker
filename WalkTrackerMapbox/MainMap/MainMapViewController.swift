//
//  MainMapViewController.swift
//  WalkTrackerMapbox
//
//  Created by Pavlentiy on 25.01.2022.
//

import UIKit
import MapboxMaps

protocol MainMapViewInputProtocol: AnyObject {
    func initMap(mapInitOptions: MapInitOptions)
}

protocol MainMapViewOutputProtocol {
    init(view: MainMapViewInputProtocol)
    func viewDidLoad()
}

class MainMapViewController: UIViewController, MainMapViewInputProtocol {
    
    var presenter: MainMapViewOutputProtocol!
    
    private let configurator: MainMapConfiguratorInputProtocol = MainMapConfigurator()
    
    var mapView: MapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(withView: self)
        
        presenter.viewDidLoad()
        
        setupSubviews(mapView)
        setConstraints()
        
        view.backgroundColor = .white
    }
    
    func initMap(mapInitOptions: MapInitOptions) {
        mapView = MapView(frame: view.bounds, mapInitOptions: mapInitOptions)
    }
    
    private func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    private func setConstraints() {
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

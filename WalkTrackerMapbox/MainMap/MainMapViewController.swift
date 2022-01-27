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
    func connectMapViewWith(consumer: CameraLocationConsumer)
}

protocol MainMapViewOutputProtocol {
    init(view: MainMapViewInputProtocol)
    func viewDidLoad()
    func mapDidLoad()
}

class MainMapViewController: UIViewController, MainMapViewInputProtocol {
    
    var presenter: MainMapViewOutputProtocol!
    
    // MARK: - Location debt
    private var cameraLocationConsumer: CameraLocationConsumer!
    private var mapView: MapView!
    
    let configurator: MainMapConfiguratorInputProtocol = MainMapConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(withView: self)
        
        presenter.viewDidLoad()
        
        setupSubviews(mapView)
        setConstraints()
        
        mapView.location.options.puckType = .puck2D()
        
        presenter.mapDidLoad()
    }
    
    func initMap(mapInitOptions: MapInitOptions) {
        mapView = MapView(frame: view.bounds, mapInitOptions: mapInitOptions)
    }
    
    func connectMapViewWith(consumer: CameraLocationConsumer) {
        cameraLocationConsumer = consumer
        
        mapView.mapboxMap.onNext(.mapLoaded) { [unowned self] _ in
            self.mapView.location.addLocationConsumer(newConsumer: cameraLocationConsumer)
        }
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

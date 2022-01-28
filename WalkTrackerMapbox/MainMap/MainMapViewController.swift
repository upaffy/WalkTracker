//
//  MainMapViewController.swift
//  WalkTrackerMapbox
//
//  Created by Pavlentiy on 28.01.2022.
//

import UIKit
import MapboxMaps

class MainMapViewController: UIViewController {
    private var mapView: MapView!
    
    var viewModel: MainMapViewModelProtocol! {
        didSet {
            viewModel.getMapSettings { [unowned self] options, consumer in
                mapView = MapView(frame: view.bounds, mapInitOptions: options)
                
                setupSubviews(mapView)
                setConstraints()
                
                mapView.mapboxMap.onNext(.mapLoaded) { [unowned self] _ in
                    self.mapView.location.addLocationConsumer(newConsumer: consumer)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MainMapViewModel()
        
        mapView.location.options.puckType = .puck2D()
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

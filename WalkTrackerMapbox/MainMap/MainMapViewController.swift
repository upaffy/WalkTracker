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
        
        viewModel.userLocation.bind { location in
            // draw line 
        }
        
        viewModel.isCameraMove.bind { [unowned self] isCameraMove in
            if isCameraMove {
                self.mapView.camera.fly(
                    to: CameraOptions(center: viewModel.userLocation.value.coordinate, zoom: 15),
                    duration: 1.3
                )
            } 
        }
        
        mapView.location.options.puckType = .puck2D()
    }
    
    // MARK: Setup UI
    private func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    private func setConstraints() {
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

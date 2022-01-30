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
                
                mapView.mapboxMap.onNext(.mapLoaded) { [unowned self] _ in
                    self.mapView.location.addLocationConsumer(newConsumer: consumer)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MainMapViewModel()
        
        setupUI(with: mapView)
        
        mapView.location.options.puckType = .puck2D()
        
        setupUserLocationBinding()
        setupIsCameraMoveBinding()
    }
    
    // MARK: - Setup bindings
    private func setupUserLocationBinding() {
        viewModel.userLocation.bind { [unowned self] _ in
            
            let previousLocations = viewModel.userPreviousLocations

            if previousLocations.isEmpty {
                // Move camera to location the first time it will open
                viewModel.moveCameraToUserLocation()
                // Create and add line layer to the map
                addLine()
            } else {
                // Draw line
                updateLine()
            }
        }
    }
    
    private func setupIsCameraMoveBinding() {
        viewModel.isCameraMove.bind { [unowned self] isCameraMove in
            if isCameraMove {
                self.mapView.camera.fly(
                    to: CameraOptions(center: viewModel.userLocation.value.coordinate, zoom: 15),
                    duration: 1.3
                )
            }
        }
    }
    
    // MARK: - Map drawing
    private func addLine() {
        viewModel.configureLineSource()
        
        let lineLayer = configureLineLayer()
        addLineLayerToMap(layer: lineLayer)
    }
    
    private func updateLine() {
        let updatedLine = viewModel.updateLineSource()
        try! self.mapView.mapboxMap.style.updateGeoJSONSource(withId: viewModel.sourceIdentifier,
                                                              geoJSON: .feature(updatedLine))
    }
    
    private func configureLineLayer() -> LineLayer {
        var lineLayer = LineLayer(id: "line-layer")
        lineLayer.source = viewModel.sourceIdentifier
        
        setLineWidthExpression(to: &lineLayer, lowZoomWidth: 5, highZoomWidth: 20)
        setLineAppearance(&lineLayer)
        
        return lineLayer
    }
    
    private func addLineLayerToMap(layer: LineLayer) {
        try! mapView.mapboxMap.style.addSource(viewModel.routeLineSource,
                                               id: viewModel.sourceIdentifier)
        
        try! mapView.mapboxMap.style.addLayer(layer)
    }
    
    private func setLineWidthExpression(to lineLayer: inout LineLayer, lowZoomWidth: Int, highZoomWidth: Int) {
        // Use an expression to define the line width at different zoom extents
        lineLayer.lineWidth = .expression(
            Exp(.interpolate) {
                Exp(.linear)
                Exp(.zoom)
                14
                lowZoomWidth
                18
                highZoomWidth
            }
        )
    }
    
    private func setLineAppearance(_ lineLayer: inout LineLayer) {
        lineLayer.lineColor = .constant(StyleColor(.red))
        lineLayer.lineCap = .constant(.round)
        lineLayer.lineJoin = .constant(.round)
    }
    
    // MARK: - Setup UI
    private func setupUI(with views: UIView...){
        setupSubviews(views)
        setConstraints()
    }
    
    private func setupSubviews(_ subviews: [UIView]) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    private func setConstraints() {
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

//
//  MainMapViewController.swift
//  WalkTrackerMapbox
//
//  Created by Pavlentiy on 28.01.2022.
//

import UIKit
import MapboxMaps

class MainMapViewController: UIViewController {
    
    private var routeLineSource: GeoJSONSource!
    private let sourceIdentifier = "user-location"
    
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
        
        setupUserLocationBinding()
        setupIsCameraMoveBinding()
        
        mapView.location.options.puckType = .puck2D()
    }
    
    // MARK: - Setup bindings
    private func setupUserLocationBinding() {
        viewModel.userLocation.bind { [unowned self] currentLocation in
            
            let previousLocations = viewModel.userPreviousLocations

            if previousLocations != [] {
                // Draw line
                updateLine(previousLocations: previousLocations, currentLocation: currentLocation)
            } else {
                addLine(location: currentLocation)
                
                // Move camera to location the first time it will open
                viewModel.moveCameraToUserLocation()
            }
            
            viewModel.userPreviousLocations.append(currentLocation)
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
    private func addLine(location: Location) {
        
        // Create a GeoJSON data source
        routeLineSource = GeoJSONSource()
        routeLineSource.data = .feature(Feature(geometry: .lineString(LineString([location.coordinate]))))
        
        // Create a line layer
        var lineLayer = LineLayer(id: "line-layer")
        lineLayer.source = sourceIdentifier
        lineLayer.lineColor = .constant(StyleColor(.red))
        
        let lowZoomWidth = 5
        let highZoomWidth = 20

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
        
        lineLayer.lineCap = .constant(.round)
        lineLayer.lineJoin = .constant(.round)
        
        // Add the lineLayer to the map.
        try! mapView.mapboxMap.style.addSource(routeLineSource, id: sourceIdentifier)
        try! mapView.mapboxMap.style.addLayer(lineLayer, layerPosition: .below("puck"))
    }
    
    private func updateLine(previousLocations: [Location], currentLocation: Location) {
        var coordinates = previousLocations.map { $0.coordinate }
        coordinates.append(currentLocation.coordinate)
        
        let updatedLine = Feature(geometry: .lineString(LineString(coordinates)))
        routeLineSource.data = .feature(updatedLine)
        try! self.mapView.mapboxMap.style.updateGeoJSONSource(withId: self.sourceIdentifier,
                                                              geoJSON: .feature(updatedLine))
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

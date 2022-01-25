//
//  MainMapViewController.swift
//  WalkTrackerMapbox
//
//  Created by Pavlentiy on 25.01.2022.
//

import UIKit

protocol MainMapViewInputProtocol: AnyObject {
    func setGreeting(greeting: String)
}

protocol MainMapViewOutputProtocol {
    init(view: MainMapViewInputProtocol)
    func viewDidLoad()
}

class MainMapViewController: UIViewController, MainMapViewInputProtocol {
    
    var presenter: MainMapViewOutputProtocol!
    
    private let configurator: MainMapConfiguratorInputProtocol = MainMapConfigurator()
    
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(withView: self)
        
        presenter.viewDidLoad()
        
        setupSubviews(label)
        setConstraints()
        
        view.backgroundColor = .white
    }
    
    func setGreeting(greeting: String) {
        label.text = greeting
    }
    
    private func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    private func setConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}

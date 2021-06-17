//
//  MapViewController.swift
//  CityFinder
//
//  Created by Taras Didukh on 17.06.2021.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    var presenter: MapPresenting!
    
    @IBOutlet private weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = presenter.name
        let coordinate = presenter.coordinate
        let location = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        mapView.setCenter(location, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.title = presenter.name
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
    }
}

extension MapViewController: MapViewProtocol {}

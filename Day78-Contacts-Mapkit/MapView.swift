//
//  MapView.swift
//  MapView
//
//  Created by Robin Phillips on 22/08/2021.
//

import SwiftUI
import MapKit


struct MapView: UIViewRepresentable {
    let latitude: Double
    let longitude: Double
    let firstName: String
    let lastName: String
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

        let annotation = MKPointAnnotation()
        annotation.title = "\(firstName) \(lastName)"
        annotation.subtitle = ""
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapView.region = MKCoordinateRegion(center: center, span: span)
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
    }
    
}

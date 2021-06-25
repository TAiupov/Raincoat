//
//  MapView.swift
//  Raincoat
//
//  Created by Тагир Аюпов on 2021-04-25.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: UIViewRepresentable {
    
    let mapView = MKMapView()
    @Binding var centerCoordinate: CLLocationCoordinate2D
    var annotations: [MKPointAnnotation] = []
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
                view.removeAnnotations(view.annotations)
                view.addAnnotations(annotations)
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
        
        var parent: MapView
        var gRecognizer = UITapGestureRecognizer()
        var panRecognizer = UIPanGestureRecognizer()
        var center: CLLocationCoordinate2D

        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
        }
        
        func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
            MapViewVM.instance.mapRect = self.parent.mapView.visibleMapRect
            MapViewVM.instance.coordinate = self.parent.mapView.centerCoordinate
            print(self.parent.mapView.centerCoordinate)
        }
        
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            
                return true
        }

        init(_ parent: MapView) {
            self.parent = parent
            self.center = MapViewVM.instance.coordinate
            super.init()
            
            self.parent.mapView.setVisibleMapRect(MKMapRect(origin: MKMapPoint(MapViewVM.instance.coordinate), size: MKMapSize(width: MapViewVM.instance.mapRect.width, height: MapViewVM.instance.mapRect.height)), animated: true)
            self.parent.mapView.setCenter(MapViewVM.instance.coordinate, animated: true)
            addTapGesture()
            addPanGesture()
            
        }

        func addTapGesture() {
            self.gRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
            self.gRecognizer.delegate = self
            self.parent.mapView.addGestureRecognizer(gRecognizer)
        }
        
        func addPanGesture() {
            self.panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panHandler(_:)))
            //            self.panRecognizer.minimumNumberOfTouches = 1
            //            self.panRecognizer.maximumNumberOfTouches = 1
            self.panRecognizer.delegate = self
            self.parent.mapView.addGestureRecognizer(panRecognizer)
            
        }
        
        @objc func tapHandler(_ gesture: UITapGestureRecognizer) {
            // position on the screen, CGPoint
            let location = gesture.location(in: self.parent.mapView)
            // position on the map, CLLocationCoordinate2D
            let coordinate = self.parent.mapView.convert(location, toCoordinateFrom: self.parent.mapView)
            MapViewVM.instance.coordinate = coordinate
            parent.mapView.setCenter(coordinate, animated: true)
            
            MapViewVM.instance.getCity(latitude: Double(coordinate.latitude), longitude: Double(coordinate.longitude))
            MapViewVM.instance.createAnnotation()
            
            print(coordinate)
        }
        
        @objc func panHandler(_ gesture: UIPanGestureRecognizer) {
            guard gesture.view != nil else {return}
            
            MapViewVM.instance.city = ""
            MapViewVM.instance.locations.removeAll()
            
        }
            
        }
    }

extension MKPointAnnotation {
    static var pin: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = MapViewVM.instance.coordinate
        return annotation
    }
}


class MapViewVM: ObservableObject {
    
    static let instance = MapViewVM(coordinate: CLLocationCoordinate2D(latitude: 49.2, longitude: -123.1))
    
    @Published var coordinate = CLLocationCoordinate2D()
    @Published var city: String = ""

    @Published var locations: [MKPointAnnotation] = []
    @Published var mapRect = MKMapRect()
    
    init(coordinate: CLLocationCoordinate2D) {
        initCoordinate(coordinate: coordinate)
    }
    
    
    func getCity(latitude: Double, longitude: Double) {
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { (placemarks, error) in
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let placemark = placemarks?.first else {
                return
            }
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.city = placemark.locality ?? ""
            }
            
        }
        
    }
    
    
    func initCoordinate(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
    
    func createAnnotation() {
        let newLocation = MKPointAnnotation()
        newLocation.coordinate = self.coordinate
        
        DispatchQueue.main.async {
            self.locations.removeAll()
            self.locations.append(newLocation)
        }
    }
}


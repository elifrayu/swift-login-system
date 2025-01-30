//
//  MapViewController.swift
//  swift-login-system
//
//  Created by elif uyar on 21.12.2024.
//
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    private let mapView = MKMapView()
    private var coordinates: [CLLocationCoordinate2D] = []
    private var currentCoordinateIndex = 0
    private var movingAnnotation: MKPointAnnotation?
    private let backButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        mapView.frame = view.bounds
        mapView.delegate = self

        setupBackButton()

        if !coordinates.isEmpty {
            markLocationsOnMap()
            drawPolyline()
            addMovingAnnotation()
            animateThroughCoordinates()
        }
    }

    func setCoordinates(_ coordinates: [CLLocationCoordinate2D]) {
        self.coordinates = coordinates
    }

    private func markLocationsOnMap() {
        for coordinate in coordinates {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
        }
    }

    private func drawPolyline() {
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
    }

    private func addMovingAnnotation() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates.first ?? CLLocationCoordinate2D()
        mapView.addAnnotation(annotation)
        movingAnnotation = annotation
    }

    private func animateThroughCoordinates() {
        guard currentCoordinateIndex < coordinates.count else {
            print("Tüm noktalar ziyaret edildi.")
            return
        }

        let nextCoordinate = coordinates[currentCoordinateIndex]

        // Hareket eden işaretçiyi güncelle
        UIView.animate(withDuration: 1.5, animations: {
            self.movingAnnotation?.coordinate = nextCoordinate
        })

        // Harita odağını yeni koordinata kaydır
        let region = MKCoordinateRegion(
            center: nextCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        mapView.setRegion(region, animated: true)

        // Sonraki noktaya geç
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.currentCoordinateIndex += 1
            self.animateThroughCoordinates()
        }
    }

    private func setupBackButton() {
        backButton.setTitle("Geri", for: .normal)
        backButton.backgroundColor = .systemBlue
        backButton.setTitleColor(.white, for: .normal)
        backButton.layer.cornerRadius = 5
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 60),
            backButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    // MKMapViewDelegate: Polyline Renderer
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .blue
            renderer.lineWidth = 3
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}

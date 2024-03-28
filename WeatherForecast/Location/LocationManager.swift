//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 25.03.2024.
//

import Foundation
import CoreLocation
import MapKit

final class LocationManager: NSObject, ObservableObject {

    @Published private(set) var currentUserCoordinate: CLLocationCoordinate2D?
    @Published private(set) var searchResults: [MKLocalSearchCompletion] = []

    private let locationManager = CLLocationManager()
    private let localSearchCompleter = MKLocalSearchCompleter()
    private let geocoder = CLGeocoder()

    override init() {
        super.init()
        localSearchCompleter.delegate = self
        localSearchCompleter.resultTypes = .address

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    deinit {
        locationManager.stopUpdatingLocation()
    }

    func getLocationByCoordinate(coordinate: CLLocationCoordinate2D) async -> String {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let placemarks = try? await geocoder.reverseGeocodeLocation(location)
        // Если не удалось найти город по координатам, то можно вместо него написать Your Location
        // нет смысла бросать ошибку
        guard let city = placemarks?.first?.locality else {
            return "Your Location"
        }
        return city
    }

    func setQueryFragmentForLocalSearch(_ fragment: String) {
        localSearchCompleter.queryFragment = fragment
    }

    func performSearchRequest(
        for completion: MKLocalSearchCompletion
    ) async throws -> CLLocationCoordinate2D {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = completion.title
        let search = MKLocalSearch(request: searchRequest)

        let response: MKLocalSearch.Response
        do {
            response = try await search.start()
        } catch {
            throw LocationError.cantPerformSearch
        }
        guard let coordinate = response.mapItems.first?.placemark.coordinate else {
            throw LocationError.cantFindCoordinate
        }
        return coordinate
    }
}

extension LocationManager: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let coordinate = locations.first?.coordinate {
            currentUserCoordinate = coordinate
        }
    }
}

extension MKLocalSearchCompletion: @unchecked Sendable {}

enum LocationError: Error {
    case cantPerformSearch
    case cantFindCoordinate
}

//
//  SearchViewModel.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 25.03.2024.
//

import Foundation
import Combine
import MapKit

@MainActor
final class SearchViewModel: ObservableObject {

    @Published private(set) var searchResults: [MKLocalSearchCompletion] = []

    private let locationManager = LocationManager()

    private var cancellables: Set<AnyCancellable> = []

    init() {
        subscribeOnLocationManager()
    }

    func updateQuery(_ query: String) {
        locationManager.setQueryFragmentForLocalSearch(query)
    }

    func performSearchRequest(
        for completion: MKLocalSearchCompletion
    ) async -> CLLocationCoordinate2D {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = completion.title
        let search = MKLocalSearch(request: searchRequest)

        let response = try? await search.start()
        guard let coordinate = response?.mapItems.first?.placemark.coordinate else {
            fatalError("no city found")
        }
        return coordinate
    }

    private func subscribeOnLocationManager() {
        locationManager.$searchResults
            .receive(on: DispatchQueue.main)
            .sink { [weak self] results in
                self?.searchResults = results
            }
            .store(in: &cancellables)
    }
}

extension MKLocalSearch.Response: @unchecked Sendable {}

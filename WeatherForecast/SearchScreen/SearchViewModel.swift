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
    @Published private(set) var coordinate: CLLocationCoordinate2D?
    @Published private(set) var errorMessage: String?

    private let locationManager = LocationManager()

    private var task: Task<Void, Never>?
    private var cancellables: Set<AnyCancellable> = []

    init() {
        subscribeOnLocationManager()
    }

    deinit {
        task?.cancel()
    }

    func updateQuery(_ query: String) {
        locationManager.setQueryFragmentForLocalSearch(query)
    }

    func resetError() {
        errorMessage = nil
    }

    func showWeather(for completion: MKLocalSearchCompletion) {
        task = Task {
            do {
                let coordinate = try await locationManager.performSearchRequest(for: completion)
                self.coordinate = coordinate
            } catch {
                handleError(error as? LocationError)
            }
        }
    }

    private func handleError(_ error: LocationError?) {
        switch error {
        case .cantPerformSearch:
            errorMessage = """
                            Cannot perform search for selected location.
                            Probably you have poor Internet connection. Try again.
                            """
        case .cantFindCoordinate:
            errorMessage = "Cannot find coordinates for selected location."
        default:
            errorMessage = "Something wend wrong."
        }
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

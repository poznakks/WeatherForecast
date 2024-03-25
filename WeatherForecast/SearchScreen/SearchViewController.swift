//
//  SearchViewController.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 25.03.2024.
//

import UIKit
import Combine
import MapKit

final class SearchViewController: UIViewController {

    private let viewModel: SearchViewModel
    private var cancellables: Set<AnyCancellable> = []

    private lazy var searchTextField: SearchTextField = {
        let textField = SearchTextField()
        view.addSubview(textField)
        return textField
    }()

    private lazy var searchResultsTableView: SearchResultsTableView = {
        let tableView = SearchResultsTableView()
        view.addSubview(tableView)
        return tableView
    }()

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
        setupConstraints()
        subscribeOnViewModel()

        searchTextField.onTextUpdate = { [weak self] text in
            self?.viewModel.updateQuery(text)
        }

        searchResultsTableView.onCellTapHandler = { [weak self] result in
            self?.showDetailViewController(for: result)
        }
    }

    private func showDetailViewController(for result: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = result.title
        let search = MKLocalSearch(request: searchRequest)
        search.start { [weak self] response, _ in
            guard let placemark = response?.mapItems.first?.placemark else {
                fatalError("no city searched")
            }
            let viewModel = WeatherViewModel(coordinate: placemark.coordinate)
            let weatherVC = WeatherViewController(viewModel: viewModel)
            self?.present(weatherVC, animated: true)
        }
    }

    private func subscribeOnViewModel() {
        viewModel.$searchResults
            .receive(on: DispatchQueue.main)
            .sink { [weak self] results in
                self?.searchResultsTableView.setResults(results)
            }
            .store(in: &cancellables)
    }

    private func setupConstraints() {
        NSLayoutConstraint.pinTopToSuperView(searchTextField, offset: 50)
        NSLayoutConstraint.pinLeadingTrailingToSuperview(searchTextField, edgeInset: 20)
        searchTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true

        NSLayoutConstraint.pinTop(searchResultsTableView, to: searchTextField, offset: 20)
        NSLayoutConstraint.pinLeadingTrailingToSuperview(searchResultsTableView, edgeInset: 10)
        NSLayoutConstraint.pinBottomToSuperView(searchResultsTableView)
    }
}

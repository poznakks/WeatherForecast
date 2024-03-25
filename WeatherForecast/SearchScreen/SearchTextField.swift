//
//  SearchTextField.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 25.03.2024.
//

import UIKit

final class SearchTextField: UITextField {

    var onTextUpdate: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        placeholder = "Search for location"
        borderStyle = .roundedRect
        layer.cornerRadius = 10
        layer.masksToBounds = true
        textColor = .black
        font = .systemFont(ofSize: 15)
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        backgroundColor = UIColor(white: 1, alpha: 0.7)
        delegate = self
        translatesAutoresizingMaskIntoConstraints = false

        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: frame.height))
        leftViewMode = .always
    }
}

extension SearchTextField: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let searchText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        onTextUpdate?(searchText)
        return true
    }
}

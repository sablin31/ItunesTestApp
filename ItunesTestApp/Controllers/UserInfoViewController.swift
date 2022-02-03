//
//  UserInfoViewController.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 29.01.2022.
//

import UIKit

class UserInfoViewController: UIViewController {
    
    private let firstNameLabel: UILabel = {
        let label = UILabel()
        label.text = "First Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lastNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Last Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ageLabel: UILabel = {
        let label = UILabel()
        label.text = "Age"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.text = "Phone"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "E-mail"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .gray
        button.setTitle("Logout", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
    }
    
    private func setupViews() {
        title = "Active User"
        view.backgroundColor = .white
        
        stackView = UIStackView(arrangedSubviews: [firstNameLabel,
                                                   lastNameLabel,
                                                   ageLabel,
                                                   phoneLabel,
                                                   emailLabel,
                                                   passwordLabel],
                                axis: .vertical,
                                spacing: 10,
                                distribution: .fillEqually)
        view.addSubview(stackView)
        view.addSubview(logoutButton)
    }
    
    @objc private func logoutButtonTapped(){
        self.navigationController?.popToRootViewController(animated: true)
    }
}

//MARK: - SetConstraints

extension UserInfoViewController {
    
    private func setConstraints() {
        if #available(iOS 11, *) {
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                stackView.trailingAnchor.constraint(equalTo: guide.trailingAnchor,constant: -20),
                stackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor,constant: 20),
                stackView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 20),
                stackView.bottomAnchor.constraint(equalTo: logoutButton.topAnchor, constant: -20)
            ])
        } else {
            NSLayoutConstraint.activate([
                stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
                stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
                stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
                stackView.bottomAnchor.constraint(equalTo: logoutButton.topAnchor, constant: -20)
            ])
        }
        
        if #available(iOS 11, *) {
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                logoutButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
                logoutButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -20),
                logoutButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -30)
            ])
        } else {
            NSLayoutConstraint.activate([
                logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                logoutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
                logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
            ])
        }
       
        NSLayoutConstraint.activate([
            logoutButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}

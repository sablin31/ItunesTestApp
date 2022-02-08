//
//  UserInfoViewController.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 29.01.2022.
//

import UIKit

class UserInfoViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
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
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(logoutButton)
        checkColorTheme()
    }
    
    deinit {
        removeDarkModeNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setConstraints()
        registerDarkModeNotification()
    }
    
    private func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkColorTheme()
        AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
    }
    
    @objc private func logoutButtonTapped(){
        self.navigationController?.popToRootViewController(animated: true)
    }
}

//MARK: - UITableViewDataSource
extension UserInfoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: nil)
            var configuration = cell.defaultContentConfiguration()
            configuration.text = "First Name"
            cell.contentConfiguration = configuration
            return cell
        }
        else if indexPath.row == 1 {
            let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: nil)
            var configuration = cell.defaultContentConfiguration()
            configuration.text = "Last Name"
            cell.contentConfiguration = configuration
            return cell
        }
        else if indexPath.row == 2 {
            let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: nil)
            var configuration = cell.defaultContentConfiguration()
            configuration.text = "Age"
            cell.contentConfiguration = configuration
            return cell
        }
        else  if indexPath.row == 3 {
            let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: nil)
            var configuration = cell.defaultContentConfiguration()
            configuration.text = "Login"
            cell.contentConfiguration = configuration
            return cell
        }
        else {
            let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: nil)
            var configuration = cell.defaultContentConfiguration()
            configuration.text = "Password"
            cell.contentConfiguration = configuration
            return cell
        }
    }
}

//MARK: - SetConstraints
extension UserInfoViewController {
    
    private func setConstraints() {
        if #available(iOS 11, *) {
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor,constant: -20),
                tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor,constant: 20),
                tableView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 20),
                tableView.bottomAnchor.constraint(equalTo: logoutButton.topAnchor, constant: -20)
            ])
        } else {
            NSLayoutConstraint.activate([
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
                tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
                tableView.bottomAnchor.constraint(equalTo: logoutButton.topAnchor, constant: -20)
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
//MARK: - Switch color on Darkmode
extension UserInfoViewController {
    private func registerDarkModeNotification(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkColorTheme),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    private func removeDarkModeNotification(){
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func checkColorTheme()
    {
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                self.view.backgroundColor = .black
            }
            else {
                self.view.backgroundColor = .white
            }
        }
    }
}

//
//  UserInfoViewController.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 29.01.2022.
//

import UIKit

protocol UserInfoDisplayLogic: AnyObject {
    var interactor: UserInfoInteractor? { get set }
    var router: RouterProtocol? { get set }

    func showPersonalData(viewModel: UserInfoModels.ShowPersonalDataUser.ViewModel)
}

class UserInfoViewController: UIViewController {
    // MARK: - Public properties

    var interactor: UserInfoInteractor?
    var router: RouterProtocol?
    // MARK: - Private properties

    private var firstName = ""
    private var lastName = ""
    private var ageString = ""
    private var phone = ""
    private var email = ""
    private var password = ""
    // MARK: - UI properties

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .gray
        button.setTitle(Constants.logoutButtonTitle, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = Constants.logoutButtonCornerRadius
        button.addTarget(
            self,
            action: #selector(logoutButtonTapped),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    // MARK: - Inheritance

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupDelegate()
        getUserData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        lockOrientation(UIInterfaceOrientationMask.all)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            changeColorUI(to: traitCollection.userInterfaceStyle)
        }
    }
    // MARK: - Action methods

    @objc private func didSwipe(_ sender: UISwipeGestureRecognizer) {
        router?.comeBackToPrevController()
    }

    @objc private func logoutButtonTapped(){
        router?.popToRoot()
    }
}
// MARK: - UITableViewDataSource

extension UserInfoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Constants.numberOfRowsInSection
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == Constants.firstNameSectionNumber {
            let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: nil)
            var configuration = cell.defaultContentConfiguration()
            configuration.text = "\(Constants.firstNameSectionPrevText) \(firstName)"
            cell.contentConfiguration = configuration
            cell.backgroundColor = .clear
            return cell
        }
        else if indexPath.row == Constants.lastNameSectionNumber {
            let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: nil)
            var configuration = cell.defaultContentConfiguration()
            configuration.text = "\(Constants.lastNameSectionPrevText) \(lastName)"
            cell.contentConfiguration = configuration
            cell.backgroundColor = .clear
            return cell
        }
        else if indexPath.row == Constants.ageSectionNumber {
            let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: nil)
            var configuration = cell.defaultContentConfiguration()
            configuration.text = "\(Constants.ageSectionPrevText) \(ageString)"
            cell.contentConfiguration = configuration
            cell.backgroundColor = .clear
            return cell
        }
        else  if indexPath.row == Constants.phoneSectionNumber {
            let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: nil)
            var configuration = cell.defaultContentConfiguration()
            configuration.text = "\(Constants.phoneSectionPrevText) \(phone)"
            cell.contentConfiguration = configuration
            cell.backgroundColor = .clear
            return cell
        }
        else if indexPath.row == Constants.emailSectionNumber {
            let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: nil)
            var configuration = cell.defaultContentConfiguration()
            configuration.text = "\(Constants.emailSectionPrevText) \(email)"
            cell.contentConfiguration = configuration
            cell.backgroundColor = .clear
            return cell
        }
        else {
            let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: nil)
            var configuration = cell.defaultContentConfiguration()
            configuration.text = "\(Constants.passwordSectionPrevText) \(password)"
            cell.contentConfiguration = configuration
            cell.backgroundColor = .clear
            return cell
        }
    }
}
// MARK: - UserInfoDisplayLogic

extension UserInfoViewController: UserInfoDisplayLogic {
    func showPersonalData(viewModel: UserInfoModels.ShowPersonalDataUser.ViewModel) {
        firstName = viewModel.firstName
        lastName = viewModel.lastName
        ageString = viewModel.ageString
        phone = viewModel.phone
        email = viewModel.email
        password = viewModel.password
        tableView.reloadData()
    }
}
// MARK: - Private methods

private extension UserInfoViewController {
    func configureUI() {
        view.addSubview(tableView)
        view.addSubview(logoutButton)
        setConstraints()
        changeColorUI(to: traitCollection.userInterfaceStyle)
        let swipeGestureRecognizerRight = UISwipeGestureRecognizer(
            target: self,
            action: #selector(didSwipe(_:))
        )
        // Configure Swipe Gesture Recognizer
        swipeGestureRecognizerRight.direction = .right
        view.addGestureRecognizer(swipeGestureRecognizerRight)
    }

    func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getUserData() {
        let request = UserInfoModels.ShowPersonalDataUser.Request()
        interactor?.fetchUserData(request: request)
    }
    
    func changeColorUI(to currentUserInterfaceStyle: UIUserInterfaceStyle) {
        if currentUserInterfaceStyle == .dark {
            view.backgroundColor = .darkGray
        } else {
            view.backgroundColor = .white
        }
    }

    func setConstraints() {
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: guide.topAnchor,
                constant: Constants.tableViewTopAnchor
            ),
            tableView.leadingAnchor.constraint(
                equalTo: guide.leadingAnchor,
                constant: Constants.tableViewLeadingAnchor
            ),
            tableView.trailingAnchor.constraint(
                equalTo: guide.trailingAnchor,
                constant: Constants.tableViewTrailingAnchor
            ),
            tableView.bottomAnchor.constraint(
                equalTo: logoutButton.topAnchor,
                constant: Constants.tableViewBottomAnchor
            )
        ])

        NSLayoutConstraint.activate([
            logoutButton.leadingAnchor.constraint(
                equalTo: guide.leadingAnchor,
                constant: Constants.logoutButtonLeadingAnchor
            ),
            logoutButton.trailingAnchor.constraint(
                equalTo: guide.trailingAnchor,
                constant: Constants.logoutButtonTrailingAnchor
            ),
            logoutButton.bottomAnchor.constraint(
                equalTo: guide.bottomAnchor,
                constant: Constants.logoutButtonBottomAnchor
            ),
            logoutButton.heightAnchor.constraint(
                equalToConstant: Constants.logoutButtonHeightAnchor
            )
        ])
    }
}
// MARK: - Constants

extension UserInfoViewController {
    private enum Constants {
        // MARK: UI constants

        static let logoutButtonTitle = "Logout"
        static let logoutButtonCornerRadius: CGFloat = 10
        
        static let numberOfRowsInSection = 6
        static let firstNameSectionNumber = 0
        static let firstNameSectionPrevText = "First name:"
        static let lastNameSectionNumber = 1
        static let lastNameSectionPrevText = "Last name:"
        static let ageSectionNumber = 2
        static let ageSectionPrevText = "Age:"
        static let phoneSectionNumber = 3
        static let phoneSectionPrevText = "Phone:"
        static let emailSectionNumber = 4
        static let emailSectionPrevText = "E-mail:"
        static let passwordSectionPrevText = "Password:"

        // MARK: Constraint constants

        static let tableViewTopAnchor: CGFloat = 20
        static let tableViewLeadingAnchor: CGFloat = 20
        static let tableViewTrailingAnchor: CGFloat = -20
        static let tableViewBottomAnchor: CGFloat = -20

        static let logoutButtonLeadingAnchor: CGFloat = 20
        static let logoutButtonTrailingAnchor: CGFloat = -30
        static let logoutButtonBottomAnchor: CGFloat = -20
        static let logoutButtonHeightAnchor: CGFloat = 40
    }
}

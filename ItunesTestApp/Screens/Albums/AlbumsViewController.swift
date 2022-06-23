//
//  AlbumsViewController.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 29.01.2022.
//

import UIKit

protocol AlbumsDisplayLogic: AnyObject {
    var interactor: AlbumsInteractor? { get set }
    var router: RouterProtocol? { get set }
    
    func showResultSearch(viewModel: AlbumsModels.ShowResultSearch.ViewModel)
}

class AlbumsViewController: UIViewController {
    // MARK: - Public properties

    var interactor: AlbumsInteractor?
    var router: RouterProtocol?
    var albums = [Album]()
    // MARK: - UI properties

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(
            AlbumsTableViewCell.self,
            forCellReuseIdentifier: AlbumsTableViewCell.reuseId
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let searchController = UISearchController(searchResultsController: nil)
    // MARK: - Inheritance

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupDelegate()
        setNavigationBar()
        setupSearchController()
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
        if #available(iOS 13.0, *) {
            if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                changeColorUI(to: traitCollection.userInterfaceStyle)
            }
        }
    }
    // MARK: - Active methods

    @objc private func userInfoButtonTapped() {
        router?.routeToUserInfoScreen()
    }
}
// MARK: - UITableViewDataSource

extension AlbumsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: AlbumsTableViewCell.reuseId,
            for: indexPath
        ) as? AlbumsTableViewCell
        let album = albums[indexPath.row]
        cell?.configurationAlbumCell(album: album)
        return cell ?? UITableViewCell()
    }
}
//MARK: - UITableViewDelegate

extension AlbumsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.rowHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.routeToDetailAlbumScreen(with: albums[indexPath.row])
    }
}
// MARK: - UISearchBarDelegate

extension AlbumsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != nil {
            let request = AlbumsModels.ShowResultSearch.Request(
                searchText: searchBar.text!.addingPercentEncoding(
                    withAllowedCharacters: .urlHostAllowed
                ) ?? ""
            )
            interactor?.fetchAlbums(request: request)
        }
    }
}
// MARK: - AlbumsDisplayLogic

extension AlbumsViewController: AlbumsDisplayLogic {
    func showResultSearch(viewModel: AlbumsModels.ShowResultSearch.ViewModel){
        if let message = viewModel.alertMessage {
            self.showAlert(
                titleMessage: Constants.alertTitle,
                message: message,
                titleButton: Constants.alertButtonTitle
            )
        } else {
            self.albums = viewModel.albums
            tableView.reloadData()
        }
    }
}
// MARK: - Private methods

private extension AlbumsViewController {
    func configureUI() {
        setupViews()
        changeColorUI(to: traitCollection.userInterfaceStyle)
        setConstraints()
    }
    
    func setupViews() {
        view.addSubview(tableView)
    }

    func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        searchController.searchBar.delegate = self
    }

    func setNavigationBar() {
        navigationItem.title = Constants.navigationBarTitle
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        let userInfoButton = createCustomButton(selector: #selector(userInfoButtonTapped))
        navigationItem.rightBarButtonItem = userInfoButton
        navigationItem.hidesBackButton = true
    }

    func setupSearchController() {
        searchController.searchBar.placeholder = Constants.searchBarPlaceholder
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func changeColorUI(to currentUserInterfaceStyle: UIUserInterfaceStyle) {
        if currentUserInterfaceStyle == .dark {
            view.backgroundColor = .darkGray
        } else {
            view.backgroundColor = .white
        }
    }

    // MARK: Constraints
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
                equalTo: guide.bottomAnchor,
                constant: Constants.tableViewBottomAnchor
            )
        ])
    }
}
// MARK: - Constants

extension AlbumsViewController {
    private enum Constants {
        // MARK: UI constants

        static let rowHeight: CGFloat = 70

        static let navigationBarTitle = "Albums"
        static let searchBarPlaceholder = "Search album"

        static let alertTitle = "Warning"
        static let alertButtonTitle = "OK"

        // MARK: Constraint constants

        static let tableViewTopAnchor: CGFloat = 10
        static let tableViewLeadingAnchor: CGFloat = 10
        static let tableViewTrailingAnchor: CGFloat = -10
        static let tableViewBottomAnchor: CGFloat = 10
    }
}

//
//  AlbumsViewController.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 29.01.2022.
//

import UIKit

class AlbumsViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(AlbumsTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let searchController = UISearchController(searchResultsController: nil)

    private var albums = [Album]()
    
    deinit {
        removeDarkModeNotification()
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        view.addSubview(tableView)
        checkColorTheme()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        setupDelegate()
        setConstraints()
        setNavigationBar()
        setupSearchController()
        registerDarkModeNotification()
    }
    
    private func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        searchController.searchBar.delegate = self
    }
    
    private func setNavigationBar() {
        navigationItem.title = "Albums"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        let userInfoButton = createCustomButton(selector: #selector(userInfoButtonTapped))
        navigationItem.rightBarButtonItem = userInfoButton
    }
    
    private func setupSearchController() {
        searchController.searchBar.placeholder = "Search album"
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    @objc private func userInfoButtonTapped() {
        let userInfoViewController = UserInfoViewController()
        navigationController?.pushViewController(userInfoViewController, animated: true)
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
    
    private func fetchAlbums(albumName: String) {
        let urlString = "https://itunes.apple.com/search?term=\(albumName)&entity=album&attribute=albumTerm"
        NetworkDataFetch.shared.fetchAlbum(urlString: urlString) { [weak self] albumModel, error in
            if error == nil {
                guard let albumModel = albumModel else { return }
                if albumModel.results != [] {
                    let sortedAlbums = albumModel.results.sorted{ firstItem, secondItem in
                        return firstItem.collectionName.compare(secondItem.collectionName) == ComparisonResult.orderedAscending
                    }
                    self?.albums = sortedAlbums
                    self?.tableView.reloadData()
                } else {
                    let alert = UIAlertController(title: "Error", message: "Album not found", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                    self?.albums = []
                    self?.tableView.reloadData()
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
}

//MARK: - UITableViewDataSource

extension AlbumsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AlbumsTableViewCell
        let album = albums[indexPath.row]
        cell.configurationAlbumCell(album: album)
        return cell
    }
}

//MARK: - UITableViewDelegate

extension AlbumsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailAlbumViewController = DetailAlbumViewController()
        let album = albums[indexPath.row]
        detailAlbumViewController.album = album
        detailAlbumViewController.title = album.artistName
        navigationController?.pushViewController(detailAlbumViewController, animated: true)
    }
}

//MARK: - UISearchBarDelegate

extension AlbumsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != nil {
            fetchAlbums(albumName: searchBar.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
        }
    }
}

//MARK: - SetConstraints

extension AlbumsViewController {
    
    private func setConstraints() {
        if #available(iOS 11, *) {
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor,constant: 10),
                tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor,constant: -10),
                tableView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 10),
                tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: 10)
            ])
        } else {
            NSLayoutConstraint.activate([
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 0),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: 0),
                tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
            ])
        }
    }
}
//MARK: - Switch color on Darkmode
extension AlbumsViewController {
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

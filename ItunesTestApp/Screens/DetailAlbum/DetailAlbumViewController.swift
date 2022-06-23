//
//  DetailViewController.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 29.01.2022.
//

import UIKit

protocol DetailAlbumDisplayLogic: AnyObject {
    var interactor: DetailAlbumInteractor? { get set }
    var router: RouterProtocol? { get set }

    func showDetailAlbum(viewModel: DetailAlbumModels.ShowDetailAlbum.ViewModel)
    func showSongsAlbum(viewModel: DetailAlbumModels.ShowSongsAlbum.ViewModel)
}

class DetailAlbumViewController: UIViewController {
    // MARK: - Public properties
    var interactor: DetailAlbumInteractor?
    var router: RouterProtocol?

    // MARK: - UI properties

    private let albumLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.albumNameLabelText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.artistNameLabelText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let releaseDataLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.releaseDateLabelText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let trackCountLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.trackCountLabelText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constants.collectionViewMinimumLineSpacing
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.backgroundColor = .clear
        collectionView.bounces = false
        collectionView.register(
            SongsCollectionViewCell.self,
            forCellWithReuseIdentifier: SongsCollectionViewCell.reuseId
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private var stackView = UIStackView()
    // MARK: - Inheritance

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setDelegate()
        showAlbumData()
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
        self.navigationController?.popViewController(animated: true)
    }
}
// MARK: - CollectionView Delegate

extension DetailAlbumViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        interactor?.songs.count ?? 0
    }
}
// MARK: - CollectionView DataSource

extension DetailAlbumViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SongsCollectionViewCell.reuseId,
            for: indexPath
        ) as! SongsCollectionViewCell
        cell.setSong(nameSongLabel: interactor?.songs[indexPath.row].trackName)
        return cell
    }
}
// MARK: - CollectionView DelegateFlowLayout

extension DetailAlbumViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(
            width: collectionView.frame.width,
            height: Constants.collectionViewDelegateHeight
        )
    }
}
// MARK: - DetailAlbumDisplayLogic

extension DetailAlbumViewController: DetailAlbumDisplayLogic {
    func showDetailAlbum(viewModel: DetailAlbumModels.ShowDetailAlbum.ViewModel) {
        albumNameLabel.text = viewModel.formattedAlbumName
        artistNameLabel.text = viewModel.formattedArtistName
        trackCountLabel.text = viewModel.formattedTrackCount
        releaseDataLabel.text = viewModel.formattedReleaseDate
    }
    func showSongsAlbum(viewModel: DetailAlbumModels.ShowSongsAlbum.ViewModel) {
        collectionView.reloadData()
    }
}
//MARK: - Private methods

private extension DetailAlbumViewController {
    func configureUI() {
        view.addSubview(albumLogo)

        stackView = UIStackView(
            arrangedSubviews: [
                albumNameLabel,
                artistNameLabel,
                releaseDataLabel,
                trackCountLabel
            ],
            axis: .vertical,
            spacing: Constants.stackViewSpacing,
            distribution: .fillProportionally
        )

        view.addSubview(stackView)
        view.addSubview(collectionView)
        setConstraints()
        changeColorUI(to: traitCollection.userInterfaceStyle)
        // Initialize Swipe Gesture Recognizer
        let swipeGestureRecognizerRight = UISwipeGestureRecognizer(
            target: self,
            action: #selector(didSwipe(_:))
        )
        // Configure Swipe Gesture Recognizer
        swipeGestureRecognizerRight.direction = .right
        view.addGestureRecognizer(swipeGestureRecognizerRight)
    }

    func setDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func changeColorUI(to currentUserInterfaceStyle: UIUserInterfaceStyle) {
        if currentUserInterfaceStyle == .dark {
            view.backgroundColor = .darkGray
        } else {
            view.backgroundColor = .white
        }
    }

    func showAlbumData() {
        showDetailAlbum()
        setImage(urlString: interactor?.album?.artworkUrl100)
        showSongsAlbum()
    }
    
    func showDetailAlbum() {
        let request = DetailAlbumModels.ShowDetailAlbum.Request()
        interactor?.fetchDetailAlbumData(request: request)
    }
    
    func showSongsAlbum() {
        let request = DetailAlbumModels.ShowSongsAlbum.Request()
        interactor?.fetchSongs(request: request)
    }

    func setImage(urlString: String?) {
        if let url = urlString {
            NetworkRequest.shared.requestData(url: URL(string: url)) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.albumLogo.image = UIImage(data: data)
                case .failure(let error):
                    self?.albumLogo.image = nil
                    print(Constants.noAlbumLogoError + error.localizedDescription)
                }
            }
        } else {
            albumLogo.image = nil
        }
    }

    func setConstraints(){
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            albumLogo.topAnchor.constraint(
                equalTo: guide.topAnchor,
                constant: Constants.albumLogoTopAnchor
            ),
            albumLogo.leadingAnchor.constraint(
                equalTo: guide.leadingAnchor,
                constant: Constants.albumLogoLeadingAnchor
            ),
            albumLogo.heightAnchor.constraint(
                equalToConstant: Constants.albumLogoHeightAnchor
            ),
            albumLogo.widthAnchor.constraint(
                equalToConstant: Constants.albumLogoWidthAnchor
            )
        ])

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(
                equalTo: guide.topAnchor,
                constant: Constants.stackViewTopAnchor
            ),
            stackView.leadingAnchor.constraint(
                equalTo: albumLogo.trailingAnchor,
                constant: Constants.stackViewLeadingAnchor

            ),
            stackView.trailingAnchor.constraint(
                equalTo: guide.trailingAnchor,
                constant: Constants.stackViewTrailingAnchor
            )
        ])

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(
                equalTo: stackView.bottomAnchor,
                constant: Constants.collectionViewTopAnchor
            ),
            collectionView.leadingAnchor.constraint(
                equalTo: albumLogo.trailingAnchor,
                constant: Constants.collectionViewLeadingAnchor
            ),
            collectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: Constants.collectionViewTrailingAnchor
            ),
            collectionView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: Constants.collectionViewBottomAnchor
            )
        ])
    }
}
// MARK: - Constants

extension DetailAlbumViewController {
    private enum Constants {
        // MARK: UI constants

        static let albumNameLabelText = "Name album"
        static let artistNameLabelText = "Name artist"
        static let releaseDateLabelText = "Release date"
        static let trackCountLabelText = "10 tracks"

        static let collectionViewMinimumLineSpacing: CGFloat = 5
        static let collectionViewDelegateHeight: CGFloat = 20
        static let stackViewSpacing: CGFloat = 10
        
        static let backendDateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZ"
        static let dateFormat = "dd.MM.yyyy"
        
        static let noAlbumLogoError = "No album logo"

        // MARK: Constraint constants

        static let albumLogoTopAnchor: CGFloat = 30
        static let albumLogoLeadingAnchor: CGFloat = 20
        static let albumLogoHeightAnchor: CGFloat = 100
        static let albumLogoWidthAnchor: CGFloat = 100
        
        static let stackViewTopAnchor: CGFloat = 30
        static let stackViewLeadingAnchor: CGFloat = 20
        static let stackViewTrailingAnchor: CGFloat = -20
        
        static let collectionViewTopAnchor: CGFloat = 10
        static let collectionViewLeadingAnchor: CGFloat = 17
        static let collectionViewTrailingAnchor: CGFloat = -10
        static let collectionViewBottomAnchor: CGFloat = -10
    }
}

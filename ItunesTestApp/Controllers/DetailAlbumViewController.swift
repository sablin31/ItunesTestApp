//
//  DetailViewController.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 29.01.2022.
//

import UIKit

class DetailAlbumViewController: UIViewController {
    
    var album: Album?
    var songs = [Song]()
    
    private let albumLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name album"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name artist"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let releaseDataLabel: UILabel = {
        let label = UILabel()
        label.text = "Release date"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let trackCountLabel: UILabel = {
        let label = UILabel()
        label.text = "10 tracks"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.bounces = false
        collectionView.register(SongsCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var stackView = UIStackView()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        view.addSubview(albumLogo)
        
        stackView = UIStackView(arrangedSubviews: [albumNameLabel,
                                                   artistNameLabel,
                                                   releaseDataLabel,
                                                   trackCountLabel],
                                axis: .vertical,
                                spacing: 10,
                                distribution: .fillProportionally)
        
        view.addSubview(stackView)
        view.addSubview(collectionView)
        checkColorTheme()
    }
    
    deinit {
        removeDarkModeNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        setDelegate()
        registerDarkModeNotification()
        setModel()
        fetchSong(album: album)
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
    
    private func setDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setModel() {
        
        guard let album = album else {return}
        
        albumNameLabel.text = album.collectionName
        artistNameLabel.text = album.artistName
        trackCountLabel.text = "\(album.trackCount) tracks:"
        releaseDataLabel.text = setDateFormat(date: album.releaseDate)
        
        guard let url = album.artworkUrl100 else {return}
        setImage(urlString: url)
    }
    
    private func setDateFormat(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZ"
        guard let backendDate = dateFormatter.date(from: date) else {return "" }

        let formatDate = DateFormatter()
        formatDate.dateFormat = "dd.MM.yyyy"
        let date = formatDate.string(from: backendDate)
        return date
    }
    
    private func setImage(urlString: String?) {
        if let url = urlString {
            NetworkRequest.shared.requestData(urlString: url) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.albumLogo.image = UIImage(data: data)
                case .failure(let error):
                    self?.albumLogo.image = nil
                    print("No album logo" + error.localizedDescription)
                }
            }
        } else {
            albumLogo.image = nil
        }
    }
}

//MARK: - CollectionView Delegate
extension DetailAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        songs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SongsCollectionViewCell
        let song = songs[indexPath.row].trackName
        cell.nameSongLabel.text = song
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(
            width: collectionView.frame.width,
            height: 20
        )
    }
    
    private func fetchSong(album: Album?) {
        guard let album = album else { return }
        let idAlbum = album.collectionId
        let urlSting = "https://itunes.apple.com/lookup?id=\(idAlbum)&entity=song"
        
        NetworkDataFetch.shared.fetchSongs(urlString: urlSting) { [weak self] songModel, error in
            if error == nil {
                guard let songModel = songModel else {return}
                self?.songs = songModel.results
                self?.collectionView.reloadData()
            } else {
                print(error?.localizedDescription)
            }
        }
    }
}

//MARK: - SetConstaints
extension DetailAlbumViewController {
    
    private func setConstraints(){
        if #available(iOS 11, *) {
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                albumLogo.topAnchor.constraint(equalTo: guide.topAnchor,constant: 30),
                albumLogo.leadingAnchor.constraint(equalTo: guide.leadingAnchor,constant: 20),
                albumLogo.heightAnchor.constraint(equalToConstant: 100),
                albumLogo.widthAnchor.constraint(equalToConstant: 100)
            ])
        } else {
            NSLayoutConstraint.activate([
                albumLogo.topAnchor.constraint(equalTo: view.topAnchor,constant: 30),
                albumLogo.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
                albumLogo.heightAnchor.constraint(equalToConstant: 100),
                albumLogo.widthAnchor.constraint(equalToConstant: 100)
            ])
        }
        
        if #available(iOS 11, *) {
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: guide.topAnchor,constant: 30),
                stackView.leadingAnchor.constraint(equalTo: albumLogo.trailingAnchor,constant: 20),
                stackView.trailingAnchor.constraint(equalTo: guide.trailingAnchor,constant: -20)
            ])
        } else {
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: view.topAnchor,constant: 30),
                stackView.leadingAnchor.constraint(equalTo: albumLogo.trailingAnchor,constant: 20),
                stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20)
            ])
        }
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor,constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: albumLogo.trailingAnchor,constant: 17),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -10)
        ])
    }
}
//MARK: - Switch color on Darkmode
extension DetailAlbumViewController {
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

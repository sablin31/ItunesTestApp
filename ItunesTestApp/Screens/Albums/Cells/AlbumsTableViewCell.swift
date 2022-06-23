//
//  AlbumsTableViewCell.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 31.01.2022.
//

import UIKit

class AlbumsTableViewCell: UITableViewCell {
    // MARK: - Public properties

    static let reuseId = String(describing: AlbumsTableViewCell.self)
    // MARK: - UI properites

    private let albumLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.albumNameLabelTitle
        label.font = UIFont.systemFont(ofSize: Constants.albumNameLabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.artistNameLabelTitle
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: Constants.artistNameLabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let trackCountLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.trackCountLabelTitle
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: Constants.trackCountLabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var stackView = UIStackView()
    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Inheritance

    override func layoutSubviews() {
        super.layoutSubviews()
        albumLogo.layer.cornerRadius = albumLogo.frame.width / Constants.albumLogoCornerRadiusDiv
    }

    func configurationAlbumCell(album: Album) {
        if let urlString = album.artworkUrl100 {
            NetworkRequest.shared.requestData(url: URL(string: urlString)) { [weak self] result in
                switch result {
                case .success(let data):
                    let image = UIImage(data: data)
                    self?.albumLogo.image = image
                case .failure(let error):
                    self?.albumLogo.image = nil
                    print(Constants.noAlbumLogoErrorDescription + error.localizedDescription)
                }
            }
            
        } else {
            albumLogo.image = nil
        }
        albumNameLabel.text = album.collectionName
        artistNameLabel.text = album.artistName
        let trackCountLabelEndingDescription = album.trackCount > Constants.minCountTrack ?
        Constants.tracksCountLabelEndingDescription : Constants.trackCountLabelEndingDescription
        trackCountLabel.text = "\(album.trackCount) \(trackCountLabelEndingDescription)"
    }
}
// MARK: - Private properties

private extension AlbumsTableViewCell {
    func setupViews() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.addSubview(albumLogo)
        self.addSubview(albumNameLabel)

        stackView = UIStackView(
            arrangedSubviews: [artistNameLabel, trackCountLabel],
            axis: .horizontal,
            spacing: Constants.stackViewSpacing,
            distribution: .equalCentering
        )
        self.addSubview(stackView)
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            albumLogo.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            albumLogo.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
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
            albumNameLabel.topAnchor.constraint(
                equalTo: self.topAnchor,
                constant: Constants.albumNameLabelTopAnchor
            ),
            albumNameLabel.leadingAnchor.constraint(
                equalTo: albumLogo.trailingAnchor,
                constant: Constants.albumLogoLeadingAnchor
            ),
            albumNameLabel.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: Constants.albumNameLabelTrailingAnchor
            ),
        ])

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(
                equalTo: albumNameLabel.bottomAnchor,
                constant: Constants.stackViewTopAnchor
            ),
            stackView.leadingAnchor.constraint(
                equalTo: albumLogo.trailingAnchor,
                constant: Constants.stackViewLeadingAnchor
            ),
            stackView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: Constants.stackViewTrailingAnchor
            ),
        ])
    }
}
// MARK: - Constants

extension AlbumsTableViewCell {
    private enum Constants {
        static let albumNameLabelTitle = "Album name"
        static let albumNameLabelFontSize: CGFloat = 20

        static let artistNameLabelTitle = "Artist name"
        static let artistNameLabelFontSize: CGFloat = 16

        static let trackCountLabelTitle = "16 tracks"
        static let trackCountLabelFontSize: CGFloat = 16
        static let trackCountLabelEndingDescription = "track"
        static let tracksCountLabelEndingDescription = "tracks"

        static let albumLogoCornerRadiusDiv: CGFloat = 2
        static let noAlbumLogoErrorDescription = "No album logo"
        static let stackViewSpacing: CGFloat = 10
        static let minCountTrack = 1
        
        // MARK: Constraint constants

        static let albumLogoLeadingAnchor: CGFloat = 15
        static let albumLogoHeightAnchor: CGFloat = 60
        static let albumLogoWidthAnchor: CGFloat = 60
        
        static let albumNameLabelTopAnchor: CGFloat = 10
        static let albumNameLabelLeadingAnchor: CGFloat = 10
        static let albumNameLabelTrailingAnchor: CGFloat = -10
        
        static let stackViewTopAnchor: CGFloat = 10
        static let stackViewLeadingAnchor: CGFloat = 10
        static let stackViewTrailingAnchor: CGFloat = -10
    }
}

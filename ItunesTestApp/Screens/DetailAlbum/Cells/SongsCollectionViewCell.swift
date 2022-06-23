//
//  SongsCollectionViewCell.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 01.02.2022.
//

import UIKit

class SongsCollectionViewCell: UICollectionViewCell {
    // MARK: - Public properties

    static let reuseId = String(describing: AlbumsTableViewCell.self)
    // MARK: - UI properites

    let nameSongLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Public methods

    func setSong(nameSongLabel: String?) {
        self.nameSongLabel.text = nameSongLabel
    }
}
// MARK: - Private methods

private extension SongsCollectionViewCell {
    func setConstraints() {
        self.addSubview(nameSongLabel)
        NSLayoutConstraint.activate([
            nameSongLabel.topAnchor.constraint(
                equalTo: self.topAnchor,
                constant: Constants.nameSongLabelTopAnchor
            ),
            nameSongLabel.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: Constants.nameSongLabelLeadingAnchor
            ),
            nameSongLabel.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: Constants.nameSongLabelTrailingAnchor
            ),
            nameSongLabel.bottomAnchor.constraint(
                equalTo: self.bottomAnchor,
                constant: Constants.nameSongLabelBottomAnchor
            )
        ])
    }
}

// MARK: - Constants

extension SongsCollectionViewCell {
    private enum Constants {
        static let nameSongLabelTopAnchor: CGFloat = 0
        static let nameSongLabelLeadingAnchor: CGFloat = 5
        static let nameSongLabelTrailingAnchor: CGFloat = -5
        static let nameSongLabelBottomAnchor: CGFloat = 0
    }
}

//
//  AlbumsPresenter.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 14.06.2022.
//

import Foundation

protocol AlbumsPresentationLogic: AnyObject {
    var viewController: AlbumsDisplayLogic? { get set }

    func presentSearchAlbums(response: AlbumsModels.ShowResultSearch.Response)
}

final class AlbumsPresenter: AlbumsPresentationLogic {
    // MARK: - Public proterties

    weak var viewController: AlbumsDisplayLogic?
    var albums = [Album]()
    // MARK: - Public methods

    func presentSearchAlbums(response: AlbumsModels.ShowResultSearch.Response) {
        var alertMessage: String?
        albums = []
        if response.error == nil {
            if let albumModel = response.albumModel {
                if albumModel.results != [] {
                    let sortedAlbums = albumModel.results.sorted{ firstItem, secondItem in
                        return firstItem.collectionName.compare(secondItem.collectionName) == ComparisonResult.orderedAscending
                    }
                    albums = sortedAlbums
                } else { alertMessage = Constants.alertMessage }
            }
        } else { alertMessage = response.error?.localizedDescription }

        let viewModel = AlbumsModels.ShowResultSearch.ViewModel(
            albums: albums,
            alertMessage: alertMessage
        )

        viewController?.showResultSearch(viewModel: viewModel)
    }
}
// MARK: - Constants

extension AlbumsPresenter {
    private enum Constants {
        // MARK: String constant
        static let alertMessage = "Album not found"
    }
}

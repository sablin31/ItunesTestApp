//
//  DetailAlbumPresenter.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 21.06.2022.
//

import Foundation

protocol DetailAlbumPresentationLogic: AnyObject {
    var viewController: DetailAlbumDisplayLogic? { get set }

    func presentDetailAlbum(response: DetailAlbumModels.ShowDetailAlbum.Response)
    func presentSongsAlbum(response: DetailAlbumModels.ShowSongsAlbum.Response)
}

final class DetailAlbumPresenter: DetailAlbumPresentationLogic {
    // MARK: - Public proterties

    var viewController: DetailAlbumDisplayLogic?
    var albums = [Album]()
    // MARK: - Public methods

    func presentDetailAlbum(response: DetailAlbumModels.ShowDetailAlbum.Response){
        let formattedAlbumName = response.albumName
        let formattedArtistName = response.artistName
        var formattedTrackCount = Constants.initTrackCount
        if let trackCount = response.trackCount {
            formattedTrackCount = trackCount == 1 ?
            Constants.oneTrackDescription : "\(trackCount) \(Constants.someTrackDesription)"
        }

        let formattedReleaseData = response.releaseDate?.setDateFormat(
            backendDateFormat: Constants.backendDateFormat,
            to: Constants.dateFormat
        )

        let viewModel = DetailAlbumModels.ShowDetailAlbum.ViewModel(
            formattedAlbumName: formattedAlbumName,
            formattedArtistName: formattedArtistName,
            formattedTrackCount: formattedTrackCount,
            formattedReleaseDate: formattedReleaseData
        )

        viewController?.showDetailAlbum(viewModel: viewModel)
    }
    
    func presentSongsAlbum(response: DetailAlbumModels.ShowSongsAlbum.Response){
        if response.error != nil {
            print(response.error?.localizedDescription as Any)
        }
        
        let viewModel = DetailAlbumModels.ShowSongsAlbum.ViewModel()
        viewController?.showSongsAlbum(viewModel: viewModel)
    }
}

extension DetailAlbumPresenter {
    private enum Constants {
        static let backendDateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZ"
        static let dateFormat = "dd.MM.yyyy"
        
        static let initTrackCount = "no tracks"
        static let oneTrackDescription = "1 track"
        static let someTrackDesription = "tracks"
    }
}

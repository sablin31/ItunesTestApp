//
//  DetailAlbumInteractor.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 21.06.2022.
//

import Foundation

protocol DetailAlbumBusinessLogic: AnyObject {
    var presenter: DetailAlbumPresentationLogic? { get set }

    func fetchDetailAlbumData(request: DetailAlbumModels.ShowDetailAlbum.Request)
    func fetchSongs(request: DetailAlbumModels.ShowSongsAlbum.Request)
}

class DetailAlbumInteractor: DetailAlbumBusinessLogic {
    // MARK: - Public properties

    var presenter: DetailAlbumPresentationLogic?

    var album: Album?
    var songs = [Song]()

    func fetchDetailAlbumData(request: DetailAlbumModels.ShowDetailAlbum.Request) {
        guard let album = album else {return}

        let albumName = album.collectionName
        let artistName = album.collectionName
        let trackCount = album.trackCount
        let releaseDate = album.releaseDate

        let responce = DetailAlbumModels.ShowDetailAlbum.Response(
            albumName: albumName,
            artistName: artistName,
            trackCount: trackCount,
            releaseDate: releaseDate
        )
        presenter?.presentDetailAlbum(response: responce)
    }

    func fetchSongs(request: DetailAlbumModels.ShowSongsAlbum.Request) {
        guard let album = album else { return }
        let idAlbum = album.collectionId
        let urlSting = Constants.createURLComponents(idAlbum: idAlbum)
        guard let url = urlSting else {return}
        NetworkDataFetch.shared.fetchSongs(url: url) { [weak self] songModel, error in
            if error == nil {
                if let songModel = songModel {
                    self?.songs = songModel.results
                }
            }
            let responce = DetailAlbumModels.ShowSongsAlbum.Response(error: error)
            self?.presenter?.presentSongsAlbum(response: responce)
        }
    }
}
// MARK: - Constants

extension DetailAlbumInteractor {
    private enum Constants {
        // MARK: URL сonstant

        static func createURLComponents(idAlbum: Int) -> URL? {
           var urlComponents = URLComponents()
           urlComponents.scheme = "https"
           urlComponents.host = "itunes.apple.com"
           urlComponents.path = "/lookup"
           urlComponents.queryItems = [
               URLQueryItem(name: "id", value: "\(idAlbum)"),
               URLQueryItem(name: "entity", value: "song"),
           ]
           return urlComponents.url
       }
    }
}

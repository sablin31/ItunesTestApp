//
//  AlbumsInteractor.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 14.06.2022.
//

import Foundation

protocol AlbumsBusinessLogic: AnyObject {
    var presenter: AlbumsPresentationLogic? { get set }
    
    func fetchAlbums(request: AlbumsModels.ShowResultSearch.Request)
}

class AlbumsInteractor: AlbumsBusinessLogic {
    // MARK: - Public properties

    var presenter: AlbumsPresentationLogic?
    var albumModel: AlbumModel?

    func fetchAlbums(request: AlbumsModels.ShowResultSearch.Request) {
        let urlFetch = Constants.createURLComponents(searchAlbum: request.searchText)
        NetworkDataFetch.shared.fetchAlbum(url: urlFetch) { [weak self] albumModel, error in
            self?.albumModel = albumModel
            let responce = AlbumsModels.ShowResultSearch.Response(
                albumModel: self?.albumModel,
                error: error
            )
            self?.presenter?.presentSearchAlbums(response: responce)
        }
    }
}
// MARK: - Constants

extension AlbumsInteractor {
    private enum Constants {
        // MARK: URL сonstant

        static func createURLComponents(searchAlbum: String) -> URL? {
           var urlComponents = URLComponents()
           urlComponents.scheme = "https"
           urlComponents.host = "itunes.apple.com"
           urlComponents.path = "/search"
           urlComponents.queryItems = [
               URLQueryItem(name: "term", value: searchAlbum),
               URLQueryItem(name: "entity", value: "album"),
               URLQueryItem(name: "attribute", value: "albumTerm"),
           ]
           return urlComponents.url
       }
    }
}

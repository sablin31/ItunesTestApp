//
//  NetworkDataFetch.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 08.02.2022.
//

import Foundation

class NetworkDataFetch {
    
    static let shared = NetworkDataFetch()
    
    private init() {}
    
    func fetchAlbum(url: URL?, responce: @escaping (AlbumModel?, Error?) -> Void) {
        NetworkRequest.shared.requestData(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let albums = try JSONDecoder().decode(AlbumModel.self, from: data)
                    responce(albums, nil)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                }
            case .failure(let error):
                print("Error recived request data: \(error.localizedDescription)")
                responce(nil, error)
            }
        }
    }

    func fetchSongs(url: URL, responce: @escaping (SongsModel?, Error?) -> Void) {
        NetworkRequest.shared.requestData(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let songs = try JSONDecoder().decode(SongsModel.self, from: data)
                    responce(songs, nil)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                }
            case .failure(let error):
                print("Error recived request data: \(error.localizedDescription)")
                responce(nil, error)
            }
        }
    }
}

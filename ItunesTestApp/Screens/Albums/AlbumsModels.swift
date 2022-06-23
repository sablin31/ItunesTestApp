//
//  AlbumsModels.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 16.06.2022.
//

import Foundation

// VIP cycles
enum AlbumsModels {
    enum ShowResultSearch {
        struct Request {
            let searchText: String
        }
        struct Response {
            let albumModel: AlbumModel?
            let error: Error?
        }
        struct ViewModel {
            let albums: [Album]
            let alertMessage: String?
        }
    }
}

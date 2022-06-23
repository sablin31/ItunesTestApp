//
//  DetailAlbumModels.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 21.06.2022.
//

import Foundation

// VIP cycles
enum DetailAlbumModels {
    enum ShowDetailAlbum {
        struct Request { }
        struct Response {
            let albumName: String?
            let artistName: String?
            let trackCount: Int?
            let releaseDate: String?
        }
        struct ViewModel {
            let formattedAlbumName: String?
            let formattedArtistName: String?
            let formattedTrackCount: String?
            let formattedReleaseDate: String?
        }
    }
    enum ShowSongsAlbum {
        struct Request { }
        struct Response {
            let error: Error?
        }
        struct ViewModel { }
    }
}

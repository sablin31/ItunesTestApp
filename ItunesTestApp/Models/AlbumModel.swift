//
//  AlbumModel.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 08.02.2022.
//

import Foundation

struct AlbumModel: Decodable, Equatable {
    let results: [Album]
    
}

struct Album: Decodable, Equatable {
    let artistName: String
    let collectionName: String
    let artworkUrl100: String?
    let trackCount: Int
    let releaseDate: String
    let collectionId: Int
}

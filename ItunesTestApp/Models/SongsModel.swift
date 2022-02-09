//
//  SongsModel.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 09.02.2022.
//

import Foundation

struct SongsModel: Decodable {
    let results: [Song]
}

struct Song: Decodable {
    let trackName: String?
}

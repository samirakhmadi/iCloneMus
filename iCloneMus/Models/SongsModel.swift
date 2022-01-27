//
//  SongsModel.swift
//  ListAlbum
//
//  Created by Samir Akhmadi on 18.01.2022.
//

import Foundation

struct SongsModel: Decodable {
    let results: [Song]
}

struct Song: Decodable {
    let trackName: String?
}

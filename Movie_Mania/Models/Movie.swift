//
//  Movie.swift
//  Movie_Mania
//
//  Created by Tahir Awan on 14/10/2026.
//

import Foundation



struct MoviesResponse: Decodable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
}

/// A Movie Instance returned by the REST API (GET /Users).
struct Movie: Codable, Hashable {
    let id: Int
    let adult: Bool
    let name: String?          // Use String? if switching between TV (/top_rated TV) and Movie endpoints
    let title: String?         // TMDB uses "title" for movies and "name" for TV shows
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double
    let voteCount: Int
}

//
//  AppConfig.swift
//  Basic_Networking_Swift
//
//  Created by Tahir Awan on 10/10/2026.
//

import Foundation



struct APPConfig: Codable{
    
    let baseURL: String
    let apiKey: String
    let baseURL_Img: String
    
    
    static let fallback = APPConfig(
        baseURL: "https://api.themoviedb.org/3/tv",
        apiKey: "7481bbcf1fcb56bd957cfe9af78205f3",
        baseURL_Img: "https://image.tmdb.org/t/p/w500"
    )
    
    private(set) static var shared: APPConfig = .fallback
    
    
}





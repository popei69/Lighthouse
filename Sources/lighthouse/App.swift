//
//  File.swift
//  
//
//  Created by Benoit PASQUIER on 18/06/2020.
//

public struct App: Codable {
    let appId: String
    let paths: [String]
    
    private enum CodingKeys: String, CodingKey {
        case appId = "appID"
        case paths = "paths"
    }
}

public struct AppDomain: Codable {
    let details: [App]
}

public struct Domain: Codable {
    let applinks: AppDomain 
}

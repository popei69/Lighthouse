//
//  File.swift
//  
//
//  Created by Benoit PASQUIER on 18/06/2020.
//

public struct App: Codable {
    public let appId: String
    public let paths: [String]
    
    private enum CodingKeys: String, CodingKey {
        case appId = "appID"
        case paths = "paths"
    }
}

public struct AppDomain: Codable {
    public let details: [App]
}

public struct Domain: Codable {
    public let applinks: AppDomain 
}

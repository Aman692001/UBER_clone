//
//  SavedLocation.swift
//  UberSwiftUITutorial
//
//  Created by Aman Jain on 31/07/23.
//

import Firebase

struct SavedLocation: Codable {
    let title: String
    let adress: String
    let Coordinates: GeoPoint
}

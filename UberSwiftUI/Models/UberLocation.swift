//
//  UberLocation.swift
//  UberSwiftUITutorial
//
//  Created by Aman on 21/07/23.
//

import Foundation
import CoreLocation

struct UberLocation: Identifiable {
    let id = NSUUID().uuidString
    let title: String
    let coordinate: CLLocationCoordinate2D
}

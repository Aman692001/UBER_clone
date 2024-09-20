//
//  GeoPoint.swift
//  UberSwiftUITutorial
//
//  Created by Aman Jain on 03/08/23.
//

import Firebase
import CoreLocation

extension GeoPoint {
    func toCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}

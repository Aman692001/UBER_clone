//
//  Trip.swift
//  UberSwiftUITutorial
//
//  Created by Aman Jain on 03/08/23.
//

import FirebaseFirestoreSwift
import Firebase

enum TripState: Int, Codable {
    case requested
    case rejectrd
    case accepted
    case passengerCancelled
    case driverCancelled
}

struct Trip: Identifiable, Codable {
    @DocumentID var tripId: String?
    let passengerUid: String
    let driverUid: String
    let passengerName: String
    let driverName: String
    let PassengerLocation: GeoPoint
    let driverLocation: GeoPoint
    let pickupLocationName: String
    let dropoffLocationName: String
    let pickupLocationAddress: String
    let pickupLocation: GeoPoint
    let dropoffLocation: GeoPoint
    let tripCost: Double
    var distanceToPassenger: Double
    var travelTimeToPassenger: Int
    var state: TripState
    
    var id: String {
        return tripId ?? ""
    }
}

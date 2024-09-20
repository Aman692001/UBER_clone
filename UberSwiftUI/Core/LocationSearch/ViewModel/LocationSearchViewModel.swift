//
//  LocationSearchViewModel.swift
//  UberSwiftUITutorial
//
//  Created by Aman on 18/07/23.
//

import Foundation
import MapKit
import Firebase

enum LocationResultsViewConfig {
    case ride
    case saveLocation(SavedLocationViewModel)
}

class LocationSearchViewModel: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedUberLocation: UberLocation?
    @Published var pickupTime: String?
    @Published var dropoffTime: String?
    
    private let searchCompleter = MKLocalSearchCompleter()
    var queryFragment: String = "" {
        didSet {
            print("DEBUG: Query fragment is \(queryFragment)")
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    var userLocation: CLLocationCoordinate2D?
    
    // MARK: - Lifecycle
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    //MARK: - Helpers
    
    func selectLocation(_ localSearch: MKLocalSearchCompletion, config: LocationResultsViewConfig) {
        locationSearch(forLocalSearchCompletion: localSearch) { response, error in
                if let error = error {
                    print("DEBUG: Location search failed with error \(error.localizedDescription)")
                    return
                }
                
                guard let item = response?.mapItems.first else { return }
                let coordinate = item.placemark.coordinate
                
                switch config {
                case .ride:
                    self.selectedUberLocation = UberLocation(title: localSearch.title,
                                                             coordinate: coordinate)
                case .saveLocation(let viewModel):
                    guard let uid = Auth.auth().currentUser?.uid else { return }
                    let savedlocation = SavedLocation(title: localSearch.title,
                                                      adress: localSearch.subtitle,
                                                      Coordinates: GeoPoint(latitude: coordinate.latitude,
                                                                            longitude: coordinate.longitude))
                    guard let encodedLocation = try? Firestore.Encoder().encode(savedlocation) else { return }
                    
                    Firestore.firestore().collection("users").document(uid).updateData([
                        viewModel.databaseKey: encodedLocation
                    ])
                }
            }
        }
        
        func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion, completion: @escaping MKLocalSearch.CompletionHandler)  {
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
            let search = MKLocalSearch(request: searchRequest)
            
            search.start(completionHandler: completion)
        }
        
        func computeRidePrice(forType type: RideType) -> Double {
            guard let destCoordinate = selectedUberLocation?.coordinate else { return 0.0 }
            guard let userCoordinate = userLocation else { return 0.0 }
            
            let userLocation = CLLocation(latitude: userCoordinate.latitude,
                                          longitude: userCoordinate.longitude)
            let destination = CLLocation(latitude: destCoordinate.latitude,
                                         longitude: destCoordinate.longitude)
            
            let tripDistanceInMeters = userLocation.distance(from: destination)
            return type.computePrice(for: tripDistanceInMeters)
            
        }
        
        func getDestinationRoute(from UserLocation: CLLocationCoordinate2D,
                                 to destination:CLLocationCoordinate2D,
                                 completion: @escaping(MKRoute) -> Void) {
            let userPlacemark = MKPlacemark(coordinate: UserLocation)
            let destPlacemark = MKPlacemark(coordinate: destination)
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: userPlacemark)
            request.destination = MKMapItem(placemark: destPlacemark)
            let directions = MKDirections(request: request)
            
            directions.calculate { response, error in
                if let error = error {
                    print("DEBUG: Failed to get directions with error \(error.localizedDescription)")
                    return
                }
                
                guard let route = response?.routes.first else { return }
                self.configurePickupAndDroppffTimes(with: route.expectedTravelTime)
                completion(route)
            }
        }
        
        func configurePickupAndDroppffTimes(with expectedTravelTime: Double) {
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            
            pickupTime = formatter.string(from: Date())
            dropoffTime = formatter.string(from: Date() + expectedTravelTime)
        }
        
    }
    //MARK: - MKLocalSearchCompleterDelegate
    
    extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
        func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
            self.results = completer.results
        }
    }

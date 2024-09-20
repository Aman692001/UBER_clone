//
//  HomeView.swift
//  UberSwiftUITutorial
//
//  Created by Aman on 18/07/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct HomeView: View {
    @State private var mapState = MapViewState.noInput
    @State private var showSideMenu = false
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        Group {
            if authViewModel.userSession == nil {
                LoginView()
            } else if let user = authViewModel.currentUser {
                NavigationStack {
                    ZStack {
                        if showSideMenu {
                            SideMenuView(user: user)
                        }
                        
                        mapView
                            .offset(x: showSideMenu ? 316 : 0)
                            .shadow(color: showSideMenu ? .black : .clear, radius: 10)
                    }
                    .onAppear {
                        showSideMenu = false
                    }
                }
            }
        }
    }
}

extension HomeView {
    var mapView: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .top) {
                UberMapViewRepresentable(mapState: $mapState)
                    .ignoresSafeArea()
                
                if mapState == .searchingForLocation {
                    LocationSearchView()
                } else if mapState == .noInput {
                    LocationSearchActivationView()
                        .padding(.top, 88)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                mapState = .searchingForLocation
                            }
                        }
                }
                
                MapViewActionButton(mapState: $mapState, showSideMenu: $showSideMenu)
                    .padding(.leading)
                    .padding(.top, 4)
            }
            
            if let user = authViewModel.currentUser {
                homeViewModel.viewForState(mapState, user: user)
                    .transition(.move(edge: .bottom))
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .onReceive(LocationManager.shared.$userLocation) { location in
            if let location = location {
                homeViewModel.userLocation = location
            }
        }
        .onReceive(homeViewModel.$selectedUberLocation) { location in
            if location != nil {
                self.mapState = .locationSelected
            }
        }
        .onReceive(homeViewModel.$trip) { trip in
            guard let trip = trip else {
                self.mapState = .noInput
                return
            }
            
            withAnimation(.spring()) {
                switch trip.state {
                case .requested:
                    self.mapState = .tripRequested
                case .rejectrd:
                    self.mapState = .tripRejected
                case .accepted:
                    self.mapState = .tripAccepted
                case .passengerCancelled:
                    self.mapState = .tripCancelledByPassenger
                case .driverCancelled:
                    self.mapState = .tripCancelledByDriver
                }
            }
        }
    }
 }


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AuthViewModel())
    }
}

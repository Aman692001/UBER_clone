//
//  SettingsView.swift
//  UberSwiftUITutorial
//
//  Created by Aman Jain on 30/07/23.
//

import SwiftUI

struct SettingsView: View {
    private let user: User
    @EnvironmentObject var viewModel: AuthViewModel
    
    init(user: User) {
        self.user = user
    }
    
    var body: some View {
        VStack {
            List {
                Section {
                    // user info header
                    HStack {
                        Image("male-profile-photo")
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 64, height: 64)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(user.fullname)
                                .font(.system(size: 16, weight: .semibold))
                            
                            Text(user.email)
                                .font(.system(size: 14))
                                .accentColor(Color.theme.primaryTextColor)
                                .opacity(0.77)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .imageScale(.small)
                            .font(.title2)
                            .foregroundColor(.gray )
                    }
                    .padding(8)
                }
                
                Section("Favorites") {
                    ForEach(SavedLocationViewModel.allCases) { viewModel in
                        NavigationLink {
                            SavedLocationSearchView(config: viewModel)
                        } label: {
                            SavedLocationRowView(viewModel: viewModel, user: user)
                        }
                    }
                }
                
                Section("Settings") {
                    SettingRowView(imageName: "bell.circle.fill", title: "Notification", tintColor: Color(.systemPurple))
                    
                    SettingRowView(imageName: "creditcard.circle.fill", title: "Payment methods", tintColor: Color(.systemBlue))

                }
                
                Section("Account") {
                    SettingRowView(imageName: "dollarsign.square.fill", title: "Make money driving", tintColor: Color(.systemGreen))
                    
                    SettingRowView(imageName: "arrow.left.square.fill", title: "Sign Out", tintColor: Color(.systemRed))
                        .onTapGesture {
                            viewModel.signout()
                        }
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView(user: dev.mockUser)
        }
    }
}

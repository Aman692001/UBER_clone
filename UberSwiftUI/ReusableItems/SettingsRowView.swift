//
//  SettingsRowView.swift
//  UberSwiftUITutorial
//
//  Created by Aman Jain on 30/07/23.
//

import SwiftUI

struct SettingRowView: View {
    let imageName: String
    let title: String
    let tintColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: imageName)
                .imageScale(.medium)
                .font(.title)
                .foregroundColor(tintColor)
            
                Text(title)
                    .font(.system(size: 15))
                    .foregroundColor(Color.theme.primaryTextColor)
        }
        .padding( 4 )
    }
}

struct SettingRowView_Previews: PreviewProvider {
    static var previews: some View {
        SettingRowView(imageName: "bell.circle.fill",
                       title: "Notifications",
                       tintColor: Color(.systemPurple))
    }
}

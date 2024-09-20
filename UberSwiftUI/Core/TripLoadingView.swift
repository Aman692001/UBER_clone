//
//  TripLoadingView.swift
//  UberSwiftUITutorial
//
//  Created by Aman Jain on 05/08/23.
//

import SwiftUI

struct TripLoadingView: View {
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 8)

            HStack {
                Text("Connecting you to a driver")
                    .font(.headline)
                    .padding()
                
                Spacer()
                 
                Spinner(lineWidth: 6, height: 64, width: 64)
                    .padding()
            }
            
            .padding(.bottom, 24)
            
        }
        .background(Color.theme.backgroundColor)
        .cornerRadius(16)
        .shadow(color: Color.theme.secondarybackgroundColor, radius: 20)
    }
}

struct TripLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        TripLoadingView()
    }
}

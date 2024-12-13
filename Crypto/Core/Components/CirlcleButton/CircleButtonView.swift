//
//  CircleButtonView.swift
//  Crypto
//
//  Created by Aref on 12/2/24.
//

import SwiftUI

struct CircleButtonView: View {
    let iconName: String
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundStyle(Color.theme.accent)
            .frame(width: 50 , height: 50)
            .background {
                Circle()
                    .foregroundStyle(Color.theme.background)
            }
            .shadow(color: Color.theme.accent.opacity(0.25), radius: 10,x: 0,y: 0)
            .padding()
        
        
    }
}

struct CircleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonView(iconName: "heart.fill")
            .padding()
            .previewLayout(.sizeThatFits)
    }
    
}

//
//  CircleButtonAnimationView.swift
//  Crypto
//
//  Created by Aref on 12/2/24.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    @Binding  var animate: Bool
    var body: some View {
        Circle()
            .stroke(lineWidth: 5)
            .scale(animate ? 1 : 0)
            .opacity(animate ? 0 : 1)
            .animation(.easeOut(duration: 1), value: animate)
            
            }
}

#Preview {
    CircleButtonAnimationView(animate: .constant(false))
}

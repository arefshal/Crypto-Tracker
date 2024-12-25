//
//  LottieLoadingView.swift
//  Crypto
//
//  Created by Aref on 12/18/24.
//

import SwiftUI
import Lottie

struct LottieLoadingView: UIViewRepresentable {
    let animationName: String
    let loopMode: LottieLoopMode

    func makeUIView(context: Context) -> LottieAnimationView {
        let view = LottieAnimationView()
        view.animation = LottieAnimation.named(animationName)
        view.loopMode = loopMode
        view.play()
        return view
    }

    func updateUIView(_ uiView: LottieAnimationView, context: Context) {}
}
struct LottieLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LottieLoadingView(animationName: "Artboard 1", loopMode: .loop)
    }
}

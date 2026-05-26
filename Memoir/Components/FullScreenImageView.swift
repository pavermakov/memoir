//
//  FullScreenImageView.swift
//  Memoir
//

import SwiftUI

struct FullScreenImageView: View {
    let image: Image
    let onDismiss: () -> Void
    
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            image
                .resizable()
                .scaledToFit()
                .scaleEffect(scale)
                .gesture(
                    MagnifyGesture()
                        .onChanged { value in
                            scale = value.magnification
                        }
                        .onEnded { _ in
                            withAnimation {
                                scale = 1.0
                            }
                        }
                )
        }
        .overlay(alignment: .topTrailing) {
            Button("Close", systemImage: "xmark") {
                onDismiss()
            }
            .labelStyle(.iconOnly)
            .font(.body.weight(.semibold))
            .foregroundStyle(.white)
            .frame(width: 36, height: 36)
            .background(.white.opacity(0.2))
            .clipShape(.circle)
            .padding()
        }
        .statusBarHidden()
    }
}

//
//  PhotosPickerButton.swift
//  Memoir
//
//  Created by Pavel Ermakov on 21.05.26.
//

import SwiftUI
import PhotosUI

struct PhotosPickerButton: View {
    @Binding var selectedPhotos: [PhotosPickerItem]
    
    var body: some View {
        PhotosPicker(
            selection: $selectedPhotos,
            matching: .images,
            photoLibrary: .shared()
        ) {
            HStack(spacing: 10) {
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 20))
                
                Text("Add Photos")
                    .font(.system(size: 15, weight: .medium, design: .serif))
            }
            .foregroundStyle(Color.memoirGold)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(Color.memoirGold.opacity(0.5), style: StrokeStyle(lineWidth: 1.5, dash: [8, 5]))
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.memoirGold.opacity(0.08))
                    )
            )
        }
    }
}

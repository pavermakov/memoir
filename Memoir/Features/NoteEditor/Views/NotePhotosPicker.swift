//
//  NotePhotosPicker.swift
//  Memoir
//
//  Created by Pavel Ermakov on 21.05.26.
//

import SwiftUI
import PhotosUI

struct NotePhotosPicker: View {
    @Binding var selectedItems: [PhotosPickerItem]
    @Binding var selectedPhotos: [NotePhoto]
    
    var body: some View {
        VStack(spacing: 0) {
            if !selectedPhotos.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: Icon.photo)
                            .font(.system(size: 14))
                            .foregroundStyle(Color.memoirGold)
                        
                        Text("\(selectedPhotos.count) photo\(selectedPhotos.count == 1 ? "" : "s") selected")
                            .font(.system(.subheadline, design: .serif))
                            .foregroundStyle(Color.memoirInk.opacity(0.6))
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 14)
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 10) {
                            ForEach(selectedPhotos, id: \.id) { photo in
                                photo.image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(.rect(cornerRadius: 8))
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .scrollIndicators(.hidden)
                    .padding(.bottom, 14)
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.memoirInk.opacity(0.03))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color.memoirInk.opacity(0.12), lineWidth: 1)
                )
            }
            
            PhotosPickerButton(selectedPhotos: $selectedItems)
                .padding(.top, 8)
        }
    }
}

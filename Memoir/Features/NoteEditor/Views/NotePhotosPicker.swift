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
    @Binding var selectedPhotoData: [Data]
    
    private func removePhoto(at index: Int) {
        withAnimation {
            selectedPhotoData.remove(at: index)
            if index < selectedItems.count {
                selectedItems.remove(at: index)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if !selectedPhotoData.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: Icon.photo)
                            .font(.system(size: 14))
                            .foregroundStyle(Color.memoirGold)
                        
                        Text("^[\(selectedPhotoData.count) photo](inflect:true) selected")
                            .font(.system(.subheadline, design: .serif))
                            .foregroundStyle(Color.memoirInk.opacity(0.6))
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 14)
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 16) {
                            ForEach(selectedPhotoData.indices, id: \.self) { index in
                                ZStack(alignment: .topTrailing) {
                                    if let uiImage = UIImage(data: selectedPhotoData[index]) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(.rect(cornerRadius: 8))
                                    }
                                    
                                    Button("Remove photo", systemImage: Icon.remove) {
                                        removePhoto(at: index)
                                    }
                                    .labelStyle(.iconOnly)
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundStyle(Color.memoirInk)
                                    .frame(width: 22, height: 22)
                                    .background(Color.memoirPaper)
                                    .clipShape(.circle)
                                    .padding(4)
                                }
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

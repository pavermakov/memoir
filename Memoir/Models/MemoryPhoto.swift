//
//  NotePhoto.swift
//  Memoir
//

import SwiftData
import SwiftUI

@Model
final class MemoryPhoto {
    @Attribute(.externalStorage) var photoData: Data = Data()
    var memory: Memory?
    
    init(photoData: Data, memory: Memory? = nil) {
        self.photoData = photoData
        self.memory = memory
    }
    
    var image: Image? {
        guard let uiImage = UIImage(data: photoData) else { return nil }
        return Image(uiImage: uiImage)
    }
}

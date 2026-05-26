//
//  NotePhoto.swift
//  Memoir
//

import SwiftData
import SwiftUI

@Model
final class NotePhoto {
    @Attribute(.externalStorage) var photoData: Data = Data()
    var note: Note?
    
    init(photoData: Data, note: Note? = nil) {
        self.photoData = photoData
        self.note = note
    }
    
    var image: Image? {
        guard let uiImage = UIImage(data: photoData) else { return nil }
        return Image(uiImage: uiImage)
    }
}

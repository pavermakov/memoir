//
//  NoteDatePicker.swift
//  Memoir
//
//  Created by Pavel Ermakov on 24.05.26.
//

import SwiftUI

struct NoteDatePicker: View {
    @Binding var date: Date
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            DatePicker(
                "Select a date",
                selection: $date,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .tint(Color.memoirGold)
            .labelsHidden()
            .padding(.horizontal)
            
            Spacer()
        }
        .background(Color.memoirPaper)
        .presentationDetents([.height(420)])
        .presentationDragIndicator(.visible)
        .onChange(of: date) { _, newValue in
            isPresented = false
        }
    }
}

#Preview {
    NoteDatePicker(date: .constant(.now), isPresented: .constant(true))
}

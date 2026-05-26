//
//  NoteDatePicker.swift
//  Memoir
//
//  Created by Pavel Ermakov on 24.05.26.
//

import SwiftUI

struct MemoryDatePicker: View {
    @Binding var date: Date
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            DatePicker(
                String(localized: "selectADate"),
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
        .presentationDragIndicator(.hidden)
        .onChange(of: date) { _, newValue in
            isPresented = false
        }
    }
}

#Preview {
    MemoryDatePicker(date: .constant(.now), isPresented: .constant(true))
}

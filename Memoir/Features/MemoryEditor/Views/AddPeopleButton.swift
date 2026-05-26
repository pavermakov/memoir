//
//  AddPeopleButton.swift
//  Memoir
//
//  Created by Pavel Ermakov on 24.05.26.
//

import SwiftUI

struct AddPeopleButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: Icon.addPeople)
                    .font(.system(size: 18))
                
                Text("addPeople")
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

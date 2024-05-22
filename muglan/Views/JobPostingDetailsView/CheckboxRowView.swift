//
//  CheckboxView.swift
//  muglan
//
//  Created by Mohit Paudyal on 5/21/24.
//

import SwiftUI
enum CheckboxOptions: String, CaseIterable {
    case w2 = "W2"
    case fullTime = "Full Time"
    case partTime = "Part Time"
    case other = "Other"
}

struct CheckboxRow: View {
    let option: CheckboxOptions
    @Binding var selectedOption: CheckboxOptions?

    var body: some View {
        Button(action: {
            self.selectedOption = self.option
        }) {
            HStack {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .resizable()
                    .frame(width: 12, height: 12)
                Text(option.rawValue)
            }
        }
    }

    private var isSelected: Bool {
        return selectedOption == option
    }
}

//
//  SearchBarView.swift
//  Crypto
//
//  Created by Aref on 12/7/24.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    var placeholder: String = "Search by name or symbol..."
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(searchText.isEmpty ? Color.theme.secondaryText : Color.theme.accent)
            TextField(placeholder, text: $searchText)
                .autocorrectionDisabled()
                .foregroundColor(Color.theme.accent)
                .overlay {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.theme.accent)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                            searchText = ""
                        }
                }
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .foregroundStyle(Color.theme.background)
                .shadow(color: Color.theme.accent.opacity(0.15), radius: 5, x: 0, y: 0)
        )
        .padding()
    }
}
struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchText: .constant(""))
    }
}

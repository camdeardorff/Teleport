//
//  Filter.swift
//  Teleport
//
//  Created by Cameron Deardorff on 7/2/20.
//

import SwiftUI


struct SearchBar: View {
    @Binding var searchTerm: String
    
    var body: some View {
        HStack {
            Image("search")
                .resizable()
                .frame(width: 16, height: 16, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .foregroundColor(.gray)
                .padding(.leading, 4)
                .padding(.vertical, 2)

            TextField("Search", text: $searchTerm)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.leading, 2)
                .padding(.vertical, 2)

        }
        .background(Color(NSColor.textBackgroundColor))
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.gray.opacity(0.5), lineWidth: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

// NOTICE-ME: this disables all focus rings for all text fields
extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}

struct Filter_Previews: PreviewProvider {
    static var previews: some View {
        return SearchBar(searchTerm: .constant("hello world"))
    }
}


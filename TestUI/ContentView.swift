//
//  ContentView.swift
//  TestUI
//
//  Created by William Pieh on 1/14/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedRange: String = "Choose a range"
    let glassAccentLight = Color(red: 190/255, green: 132/255, blue: 93/255)
    let glassAccentDark = Color(red: 88/255, green: 30/255, blue: 0/255)
    @Environment(\.colorScheme) var colorScheme


    var body: some View {
        ZStack {

        VStack(spacing: 20) {
            Menu {
                Button("140-145") {
                    selectedRange = "140-145"
                }
                Button("150-155") {
                    selectedRange = "150-155"
                }
                Button("160-165") {
                    selectedRange = "160-165"
                }
                Button("165-170") {
                    selectedRange = "165-170"
                }
            } label: {
                HStack {
                    Text(selectedRange)
                        .foregroundStyle(selectedRange == "Choose a range" ? .orange.opacity(0.6) : .primary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundStyle(Color(red: 190, green: 132, blue: 93))
                }
                .padding()
                .background(Color(uiColor: .secondarySystemFill))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(uiColor: .systemGray4), lineWidth: 1)
                )
            }
            .padding(.horizontal)
            Button {
                
            }
            label: {
                Spacer()
                Text("hi")
                    .foregroundStyle(.primary)
                Spacer()
            }
            .buttonStyle(.glassProminent)
            .modify {
                view in
                    if(colorScheme == .light) {
                        view.tint(glassAccentLight)
                    }
                    else {
                        view.tint(glassAccentDark)
                    }
            }
            .padding(.horizontal)
        }
    }
    }


}

#Preview {
    ContentView()
}

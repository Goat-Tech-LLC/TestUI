//
//  View+Modify.swift
//  HornScore
//
//  Created by Obadiah Fusco on 11/27/25.
//
import SwiftUI

extension View {
    @ViewBuilder
    func modify<Content: View>(@ViewBuilder _ transform: (Self) -> Content) -> some View {
    transform(self)
}
}

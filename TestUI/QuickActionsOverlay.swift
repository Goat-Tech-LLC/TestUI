//
//  QuickActionsOverlay.swift
//  TestUI
//
//  Created by William Pieh on 2/7/26.
//

import SwiftUI
import UIKit

// MARK: - Quick Action Model

struct QuickActionItem: Identifiable {
    let id = UUID()
    let icon: String
    let label: String
    let useCustomIcon: Bool

    init(icon: String, label: String, useCustomIcon: Bool = false) {
        self.icon = icon
        self.label = label
        self.useCustomIcon = useCustomIcon
    }
}

// MARK: - Quick Actions Panel

struct QuickActionsPanel: View {
    var onAction: ((QuickActionItem) -> Void)? = nil

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)

    private let actions: [QuickActionItem] = [
        QuickActionItem(icon: "scope", label: "Create Score"),
        QuickActionItem(icon: "rectangle.stack", label: "Create Album"),
        QuickActionItem(icon: "rectangle.stack", label: "Create Album"),
        QuickActionItem(icon: "rectangle.stack", label: "Create Album"),
        QuickActionItem(icon: "rectangle.stack", label: "Create Album"),
    ]

    var body: some View {
        VStack(spacing: 16) {
            ForEach(Array(actions.enumerated()), id: \.element.id) { index, action in
                QuickActionButton(item: action) {
                    onAction?(action)
                }
                .transition(.blurReplace)
                .animation(.spring(response: 0.35, dampingFraction: 0.82), value: action.id)
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
        .glassEffect(.clear.interactive(), in: .rect(cornerRadius: 34))
    }
}

// MARK: - Quick Action Button

struct QuickActionButton: View {
    let item: QuickActionItem
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Circle()
                    .fill(Color(UIColor.tertiarySystemBackground))
                    .frame(width: 56, height: 56)
                    .overlay {
                            Image(systemName: item.icon)
                                .font(.system(size: 24))
                                .foregroundStyle(.primary)
                    }

                Text(item.label)
                    .font(.system(size: 17),)
                    .foregroundStyle(.primary)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(minHeight: 30)
            }
        }
        .buttonStyle(.plain)
    }

    /// Metallic sphere for special items like "Ask Bevel"
    private var metallicSphere: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        .white.opacity(0.95),
                        Color(white: 0.75),
                        Color(white: 0.5),
                        Color(white: 0.35),
                    ],
                    center: .init(x: 0.35, y: 0.3),
                    startRadius: 1,
                    endRadius: 22
                )
            )
            .frame(width: 36, height: 36)
            .shadow(color: .white.opacity(0.15), radius: 6, x: -2, y: -2)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        QuickActionsPanel()
            .padding()
    }
    .preferredColorScheme(.dark)
}

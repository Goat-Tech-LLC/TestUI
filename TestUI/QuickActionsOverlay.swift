//
//  QuickActionsOverlay.swift
//  TestUI
//
//  Created by William Pieh on 2/7/26.
//

import SwiftUI
import UIKit

// MARK: - Design Tokens

//enum DesignTokens {
//    // MARK: - Colors
//    enum Colors {
//        static let labelsPrimary = Color(.label)
//        static let labelsSecondary = Color(.secondaryLabel)
//        static let backgroundsPrimaryElevated = Color(.systemBackground)
//        static let backgroundsSecondaryElevated = Color(.secondarySystemBackground)
//        static let backgroundsTertiaryElevated = Color(.tertiarySystemBackground)
//    }
//
//    // MARK: - Spacing
//    enum Spacing {
//        static let spacing2: CGFloat = 8
//        static let spacing3: CGFloat = 12
//        static let spacing4: CGFloat = 16
//        static let spacing6: CGFloat = 24
//    }
//
//    // MARK: - Radius
//    enum Radius {
//        static let medium: CGFloat = 12
//        static let listGroup: CGFloat = 26
//        static let actionPanel: CGFloat = 34
//    }
//
//    // MARK: - Sizes
//    enum Sizes {
//        static let iconCircle: CGFloat = 56
//        static let iconGlyph: CGFloat = 24
//    }
//}

// MARK: - Quick Action Model

//struct QuickActionItem: Identifiable {
//    let id = UUID()
//    let icon: String
//    let label: String
//    let useCustomIcon: Bool
//
//    init(icon: String, label: String, useCustomIcon: Bool = false) {
//        self.icon = icon
//        self.label = label
//        self.useCustomIcon = useCustomIcon
//    }
//}
//
//// MARK: - Quick Actions Panel
//
//struct QuickActionsPanel: View {
//    var onAction: ((QuickActionItem) -> Void)? = nil
//
//    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)
//
//    private let actions: [QuickActionItem] = [
//        QuickActionItem(icon: "scope", label: "Create Score"),
//        QuickActionItem(icon: "rectangle.stack", label: "Create Album"),
//        QuickActionItem(icon: "rectangle.stack", label: "Create Album"),
//        QuickActionItem(icon: "rectangle.stack", label: "Create Album"),
//        QuickActionItem(icon: "rectangle.stack", label: "Create Album"),
//    ]
//
//    var body: some View {
//        VStack(spacing: DesignTokens.Spacing.spacing4) {
//            ForEach(Array(actions.enumerated()), id: \.element.id) { index, action in
//                QuickActionButton(item: action) {
//                    onAction?(action)
//                }
//                .transition(.blurReplace)
//                .animation(.spring(response: 0.35, dampingFraction: 0.82), value: action.id)
//            }
//        }
//        .padding(.vertical, DesignTokens.Spacing.spacing4)
//        .padding(.horizontal, DesignTokens.Spacing.spacing4)
//        .glassEffect(.clear.interactive(), in: .rect(cornerRadius: 34))
//    }
//}

// MARK: - Quick Action Button

//struct QuickActionButton: View {
//    let item: QuickActionItem
//    let action: () -> Void
//
//    var body: some View {
//        Button(role: .confirm, action: action) {
//            HStack(spacing: DesignTokens.Spacing.spacing2) {
//                Circle()
//                    .fill(DesignTokens.Colors.backgroundsTertiaryElevated)
//                    .frame(width: DesignTokens.Sizes.iconCircle, height: DesignTokens.Sizes.iconCircle)
//                    .overlay {
//                            Image(systemName: item.icon)
//                                .font(.system(size: DesignTokens.Sizes.iconGlyph))
//                                .foregroundStyle(DesignTokens.Colors.labelsPrimary)
//                    }
//
//                Text(item.label)
//                    .font(.system(size: 17),)
//                    .foregroundStyle(DesignTokens.Colors.labelsPrimary)
//                    .fontWeight(.bold)
//                    .multilineTextAlignment(.center)
//                    .lineLimit(2)
//                    .frame(minHeight: 30)
//            }
//        }
//        .buttonStyle(.plain)
//    }
//
//    /// Metallic sphere for special items like "Ask Bevel"
//    private var metallicSphere: some View {
//        Circle()
//            .fill(
//                RadialGradient(
//                    colors: [
//                        .white.opacity(0.95),
//                        Color(white: 0.75),
//                        Color(white: 0.5),
//                        Color(white: 0.35),
//                    ],
//                    center: .init(x: 0.35, y: 0.3),
//                    startRadius: 1,
//                    endRadius: 22
//                )
//            )
//            .frame(width: 36, height: 36)
//            .shadow(color: .white.opacity(0.15), radius: 6, x: -2, y: -2)
//    }
//}

// MARK: - Preview

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
//        QuickActionsPanel()
            .padding()
    }
    .preferredColorScheme(.dark)
}

//
//  QuickActionsTabDemo.swift
//  TestUI
//
//  Created by William Pieh on 2/7/26.
//

// MARK: - Concept
//
// A "meta action" tab bar pattern using the native iOS 26 Liquid Glass tab bar.
// The rightmost tab is a + button that reveals a floating quick-actions overlay
// instead of navigating. Tapping + morphs into X, dims the content, and slides
// up a 3x3 grid of contextual actions. The native tab bar stays on top throughout.
//
// The overlay lives inside the tab content area so the Liquid Glass tab bar
// renders above it naturally - no custom tab bar needed.

import SwiftUI
import UIKit

// MARK: - Tab Definition

enum QuickActionsTab: String {
    case home, journal, fitness, biology, actions
}

// MARK: - Root Demo View

struct QuickActionsTabDemo: View {
    @State private var selectedTab: QuickActionsTab = .home
    @State private var showQuickActions = false
    @State private var bottomInset: CGFloat = 0

    /// Custom binding that intercepts selection of the .actions tab
    /// to toggle the overlay instead of navigating.
    private var tabSelection: Binding<QuickActionsTab> {
        Binding(
            get: { selectedTab },
            set: { newTab in
                if newTab == .actions {
                    var transaction = Transaction()
                    transaction.disablesAnimations = true
                    withTransaction(transaction) {
                        selectedTab = selectedTab // force no change
                    }
                    showQuickActions.toggle()
                }
            }        )
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: tabSelection) {
                Tab("Home", systemImage: "house.fill", value: QuickActionsTab.home) {
                    DemoHomeContent()
                        .overlay { scrim }
                }

                Tab("Journal", systemImage: "doc.text.fill", value: .journal) {
                    DemoPlaceholderTab(tab: .journal).overlay { scrim }
                }

                Tab("Fitness", systemImage: "figure.run", value: .fitness) {
                    DemoPlaceholderTab(tab: .fitness).overlay { scrim }
                }

                Tab("Biology", systemImage: "heart.fill", value: .biology) {
                    DemoPlaceholderTab(tab: .biology).overlay { scrim }
                }

                Tab(value: QuickActionsTab.actions, role: .search) {
                    Color.clear
                } label: {
                    Image(systemName: "plus")
                }
            }

            // Panel lives outside TabView for reliable animation.
            HStack{
                Spacer()
                QuickActionsPanel { item in
                    print("Tapped: \(item.label)")
                    showQuickActions = false
                }
                .padding(.horizontal, 16)
                .padding(.bottom, bottomInset + 60)
                .opacity(showQuickActions ? 1 : 0)
                .scaleEffect(showQuickActions ? 1 : 1.10)
                .allowsHitTesting(showQuickActions)
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: showQuickActions)
    }

    /// Scrim lives inside each Tab's content so the Liquid Glass tab bar
    /// renders on top of it. No transitions needed — just animated opacity.
    private var scrim: some View {
        Color.black
            .opacity(showQuickActions ? 0.4 : 0)
            .ignoresSafeArea()
            .onTapGesture { showQuickActions = false }
            .allowsHitTesting(showQuickActions)
            .animation(.spring(response: 0.4, dampingFraction: 0.82), value: showQuickActions)
    }
}

// MARK: - Demo Home Content

/// Placeholder home screen with health-style cards to show content behind the overlay.
private struct DemoHomeContent: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Status pills
                    HStack(spacing: 12) {
                        StatusPill(
                            icon: "figure.walk",
                            label: "Active",
                            detail: "Until changed",
                            color: .green
                        )
                        StatusPill(
                            icon: "moon.fill",
                            label: "67\u{00B0}F",
                            detail: "Phoenix, AZ",
                            color: .indigo
                        )
                    }

                    // Nutrition card
                    GroupBox {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Today's foods")
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "arrow.right")
                                    .foregroundStyle(.secondary)
                            }

                            HStack(spacing: 24) {
                                NutrientLabel(icon: "fork.knife", value: "0g")
                                NutrientLabel(icon: "flame.fill", value: "0g")
                                NutrientLabel(icon: "drop.fill", value: "0g")
                            }

                            HStack {
                                Circle()
                                    .fill(.secondary)
                                    .frame(width: 6, height: 6)
                                Text("Blood glucose")
                                    .font(.subheadline)
                                Spacer()
                                Text("\u{2013} mg/dl")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    } label: {
                        Text("Nutrition")
                            .font(.title3.bold())
                    }

                    // Calories card
                    GroupBox {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Calories")
                                        .font(.headline)
                                    Text("1,800 kcal left")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text("1.8k")
                                    .font(.headline)
                                    .foregroundStyle(.green)
                            }

                            GeometryReader { geo in
                                Capsule()
                                    .fill(Color(UIColor.systemGray5))
                                    .overlay(alignment: .leading) {
                                        Capsule()
                                            .fill(.blue)
                                            .frame(width: geo.size.width * 0.08)
                                    }
                            }
                            .frame(height: 4)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .navigationTitle("Today, February 7")
        }
    }
}

// MARK: - Helper Views

private struct StatusPill: View {
    let icon: String
    let label: String
    let detail: String
    let color: Color

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 32, height: 32)
                .background(color.gradient, in: Circle())

            VStack(alignment: .leading, spacing: 1) {
                Text(label)
                    .font(.subheadline.bold())
                Text(detail)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(10)
        .background(
            Color(UIColor.secondarySystemBackground),
            in: RoundedRectangle(cornerRadius: 14)
        )
    }
}

private struct NutrientLabel: View {
    let icon: String
    let value: String

    var body: some View {
        Label(value, systemImage: icon)
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }
}

private struct DemoPlaceholderTab: View {
    let tab: QuickActionsTab

    var title: String {
        tab.rawValue.capitalized
    }

    var icon: String {
        switch tab {
        case .home:     return "house.fill"
        case .journal:  return "doc.text.fill"
        case .fitness:  return "figure.run"
        case .biology:  return "heart.fill"
        case .actions:  return "plus"
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 48))
                    .foregroundStyle(.tertiary)
                Text(title)
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.systemBackground))
            .navigationTitle(title)
        }
    }
}

// MARK: - Previews

#Preview("Quick Actions - Dark") {
    QuickActionsTabDemo()
        .preferredColorScheme(.dark)
}

#Preview("Quick Actions - Light") {
    QuickActionsTabDemo()
        .preferredColorScheme(.light)
}

//
//  ShareSheet.swift
//  TestUI
//
//  Created by William Pieh on 1/25/26.
//

// MARK: - Design Documentation
//
// This share sheet uses a deliberate approach to iOS background colors that differs
// from the typical "grouped" pattern used in Settings-style screens.
//
// ## Background Strategy
//
// We use the NON-GROUPED elevated pattern:
// - Sheet background: Primary Elevated (systemBackground) → white/BLACK
// - Action containers: Secondary Elevated (secondarySystemBackground) → light gray/dark gray
//
// This gives us:
// - Light mode: Clean white sheet with subtle gray action rows
// - Dark mode: TRUE BLACK background (OLED-friendly) with elevated gray action rows
//
// ## Why Not Grouped?
//
// The "grouped" pattern (systemGroupedBackground) would give us:
// - Light: Gray background (#F2F2F7) with white cells
// - Dark: Elevated gray (#1C1C1E) background, not true black
//
// For a share sheet with prominent actions, we want maximum contrast. The grouped
// pattern makes dark mode look "muddy" - everything becomes shades of gray.
// Our approach keeps dark mode crisp with true black and clearly elevated actions.
//
// ## Figma Token Mapping
//
// | Figma Token              | SwiftUI                      | Light    | Dark     |
// |--------------------------|------------------------------|----------|----------|
// | Primary - Elevated       | systemBackground             | #FFFFFF  | #000000  |
// | Secondary - Elevated     | secondarySystemBackground    | #F2F2F2  | #1C1C1E  |
//
// ## Layout Structure
//
// - Content preview: Flat on primary background
// - Send To profiles: Flat horizontal scroll
// - Quick Share rows: Grouped in secondary elevated container (26pt radius)
// - More Options row: Grouped in secondary elevated container (26pt radius)
//
// The section headers remain flat/outside the containers to create visual hierarchy
// without boxing everything in like a Settings screen.

import SwiftUI
import UIKit

// MARK: - Design Tokens

enum DesignTokens {
    // MARK: - Colors (using SwiftUI semantic colors for light/dark mode support)
    enum Colors {
        // Labels
        static let labelsPrimary = Color(.label)
        static let labelsSecondary = Color(.secondaryLabel)

        // Backgrounds - Elevated (for sheets/modals)
        // Primary Elevated = native sheet background (white light / black dark)
        // Secondary Elevated = action containers (light gray / dark gray)
        static let backgroundsPrimaryElevated = Color(.systemBackground)
        static let backgroundsSecondaryElevated = Color(.secondarySystemBackground)

        // Separators
        static let separatorsVibrant = Color(.separator)

        // Accents
        static let accentsBlue = Color.accentColor
        static let accentsGreen = Color.green
        static let graysGray = Color.gray

        static let chevronTint = Color.accentColor.opacity(0.5)
    }

    // MARK: - Spacing
    enum Spacing {
        static let spacing2: CGFloat = 8
        static let spacing3: CGFloat = 12
        static let spacing4: CGFloat = 16
        static let spacing6: CGFloat = 24
        static let spacingBase: CGFloat = 4
    }

    // MARK: - Radius
    enum Radius {
        static let medium: CGFloat = 12
        static let listGroup: CGFloat = 26
    }

    // MARK: - Sizes
    enum Sizes {
        static let profileImage: CGFloat = 66
        static let thumbnailImage: CGFloat = 66
        static let rowHeight: CGFloat = 52
        static let separatorHeight: CGFloat = 21
    }
}

// MARK: - Color Hex Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Custom App Share Sheet

struct CustomShareSheet: View {
    @Environment(\.dismiss) private var dismiss
    let contentToShare: ShareContent

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Content Preview
                    contentPreview
                        .padding(.horizontal, DesignTokens.Spacing.spacing4)
                        .padding(.vertical, DesignTokens.Spacing.spacing3)

                    Divider()
                        .padding(.horizontal, DesignTokens.Spacing.spacing4)

                    // Send To section
                    sendToPeopleSection

                    Divider()
                        .padding(.horizontal, DesignTokens.Spacing.spacing4)

                    // Quick Share section
                    quickShareSection

                    Divider()
                        .padding(.horizontal, DesignTokens.Spacing.spacing4)

                    // More Options section
                    moreOptionsSection

                    Spacer()
                }
            }
            .navigationTitle("Share")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private var contentPreview: some View {
        HStack(spacing: DesignTokens.Spacing.spacing3) {
            // Thumbnail image
            RoundedRectangle(cornerRadius: DesignTokens.Radius.medium)
                .fill(.blue.gradient)
                .frame(
                    width: DesignTokens.Sizes.thumbnailImage,
                    height: DesignTokens.Sizes.thumbnailImage
                )
                .overlay {
                    Image(systemName: contentToShare.iconName)
                        .font(.title2)
                        .foregroundStyle(.white)
                }

            VStack(alignment: .leading, spacing: DesignTokens.Spacing.spacingBase) {
                Text(contentToShare.title)
                    .font(.headline)
                    .foregroundColor(DesignTokens.Colors.labelsPrimary)

                Text(contentToShare.subtitle)
                    .font(.subheadline)
                    .foregroundColor(DesignTokens.Colors.labelsSecondary)
                    .lineLimit(2)
            }

            Spacer()
        }
    }

    private var sendToPeopleSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.spacing3) {
            Text("Send To")
                .font(.headline)
                .foregroundColor(DesignTokens.Colors.labelsPrimary)
                .padding(.horizontal, DesignTokens.Spacing.spacing4)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DesignTokens.Spacing.spacing6) {
                    ForEach(mockUsers) { user in
                        ShareProfileView(user: user) {
                            shareToUser(user)
                        }
                    }
                }
                .padding(.horizontal, DesignTokens.Spacing.spacing4)
            }
        }
        .padding(.vertical, DesignTokens.Spacing.spacing3)
    }

    private var quickShareSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.spacing3) {
            Text("Quick Share")
                .font(.headline)
                .foregroundColor(DesignTokens.Colors.labelsPrimary)
                .padding(.horizontal, DesignTokens.Spacing.spacing4)

            VStack(spacing: 0) {
                ShareOptionRow(
                    icon: "message.fill",
                    title: "Messages",
                    iconColor: DesignTokens.Colors.accentsGreen,
                    action: shareViaMessages
                )

                Divider()
                    .padding(.leading, 52)

                ShareOptionRow(
                    icon: "link",
                    title: "Copy Link",
                    iconColor: DesignTokens.Colors.accentsBlue,
                    action: copyLink
                )
            }
            .background(DesignTokens.Colors.backgroundsSecondaryElevated)
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.listGroup))
            .padding(.horizontal, DesignTokens.Spacing.spacing4)
        }
        .padding(.vertical, DesignTokens.Spacing.spacing3)
    }

    private var moreOptionsSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.spacing3) {
            Text("More Options")
                .font(.headline)
                .foregroundColor(DesignTokens.Colors.labelsPrimary)
                .padding(.horizontal, DesignTokens.Spacing.spacing4)

            ShareOptionRow(
                icon: "ellipsis.circle.fill",
                title: "Share via...",
                iconColor: DesignTokens.Colors.graysGray,
                action: {}
            )
            .background(DesignTokens.Colors.backgroundsSecondaryElevated)
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.listGroup))
            .padding(.horizontal, DesignTokens.Spacing.spacing4)
        }
        .padding(.vertical, DesignTokens.Spacing.spacing3)
    }

    // MARK: - Actions

    private func shareToUser(_ user: MockUser) {
        print("Sharing to \(user.name)")
    }

    private func shareViaMessages() {
        print("Opening Messages")
    }

    private func copyLink() {
        UIPasteboard.general.string = contentToShare.url?.absoluteString ?? contentToShare.title
        print("Link copied!")
        dismiss()
    }
}

// MARK: - Share Profile View

struct ShareProfileView: View {
    let user: MockUser
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: DesignTokens.Spacing.spacing2) {
                // Profile circle
                Circle()
                    .fill(user.color.gradient)
                    .frame(
                        width: DesignTokens.Sizes.profileImage,
                        height: DesignTokens.Sizes.profileImage
                    )
                    .overlay {
                        if let imageName = user.imageName {
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                        } else {
                            Text(user.initials)
                                .font(.system(size: 22, weight: .bold))
                                .tracking(-0.26)
                                .foregroundColor(DesignTokens.Colors.labelsPrimary)
                        }
                    }

                // Name
                Text(user.name)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(DesignTokens.Colors.labelsPrimary)
                    .lineLimit(1)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Share Option Row

struct ShareOptionRow: View {
    let icon: String
    let title: String
    let iconColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 0) {
                // Icon
                Image(systemName: icon)
                    .font(.system(size: 17))
                    .foregroundColor(iconColor)
                    .frame(width: 29)
                    .padding(.trailing, DesignTokens.Spacing.spacing2)

                // Title
                Text(title)
                    .font(.system(size: 17, weight: .regular))
                    .tracking(-0.43)
                    .foregroundColor(DesignTokens.Colors.accentsBlue)

                Spacer()

                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(DesignTokens.Colors.chevronTint)
            }
            .frame(height: DesignTokens.Sizes.rowHeight)
            .padding(.horizontal, DesignTokens.Spacing.spacing4)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Rounded Corner Shape

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Models

struct ShareContent {
    let title: String
    let subtitle: String
    let iconName: String
    let url: URL?
    let data: Any?
}

struct MockUser: Identifiable {
    let id = UUID()
    let name: String
    let initials: String
    let color: Color
    let imageName: String?

    init(name: String, initials: String, color: Color, imageName: String? = nil) {
        self.name = name
        self.initials = initials
        self.color = color
        self.imageName = imageName
    }
}

let mockUsers = [
    MockUser(name: "2025 Hunt", initials: "25", color: .blue),
    MockUser(name: "Jake", initials: "JK", color: .green),
    MockUser(name: "Blake", initials: "BC", color: Color(.systemGray5)),
    MockUser(name: "Harris", initials: "HR", color: .orange),
    MockUser(name: "Sarah", initials: "SK", color: .pink)
]

// MARK: - Native Share Sheet Wrapper

#if os(iOS)
/// A SwiftUI wrapper for UIActivityViewController that allows sharing content
struct NativeShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    var activities: [UIActivity]? = nil
    var excludedActivityTypes: [UIActivity.ActivityType]? = nil
    var completionHandler: ((UIActivity.ActivityType?, Bool, [Any]?, Error?) -> Void)? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: items,
            applicationActivities: activities
        )

        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = completionHandler

        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No updates needed
    }
}
#endif

// MARK: - Real-World Example with Both Share Options

#if os(iOS)
struct ContentDetailView: View {
    let contentTitle: String
    let contentBody: String
    let contentURL: URL?

    @State private var showingCustomShare = false
    @State private var showingNativeShare = false

    var shareContent: ShareContent {
        ShareContent(
            title: contentTitle,
            subtitle: contentBody,
            iconName: "doc.text.fill",
            url: contentURL,
            data: contentBody
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(contentTitle)
                    .font(.largeTitle.bold())

                Text(contentBody)
                    .font(.body)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Content")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button {
                        showingCustomShare = true
                    } label: {
                        Label("Share in App", systemImage: "heart.circle.fill")
                    }

                    Button {
                        showingNativeShare = true
                    } label: {
                        Label("Share via System", systemImage: "square.and.arrow.up")
                    }
                } label: {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            }
        }
        // Custom share sheet
        .sheet(isPresented: $showingCustomShare) {
            CustomShareSheet(contentToShare: shareContent)
        }
        // Native iOS share sheet
        .sheet(isPresented: $showingNativeShare) {
            NativeShareSheet(
                items: [contentTitle, contentBody, contentURL].compactMap { $0 },
                excludedActivityTypes: [.print, .assignToContact]
            )
        }
    }
}

// MARK: - Demo View

struct ShareSheetDemo: View {
    @State private var showingCustomShare = false
    @State private var showingNativeShare = false

    var body: some View {
        NavigationView {
            List {
                Section {
                    Text("This demo shows both custom and native share sheets")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                }

                Section("Real-World Example") {
                    NavigationLink {
                        ContentDetailView(
                            contentTitle: "Amazing Content!",
                            contentBody: "Check out this amazing content that you can share in multiple ways.",
                            contentURL: URL(string: "https://www.apple.com")
                        )
                    } label: {
                        Label("View Content with Share Options", systemImage: "doc.text")
                    }
                }

                Section("Try Both Share Sheets") {
                    Button {
                        showingCustomShare = true
                    } label: {
                        Label("Custom Share Sheet (Instagram-style)", systemImage: "heart.circle.fill")
                    }

                    Button {
                        showingNativeShare = true
                    } label: {
                        Label("Native iOS Share Sheet", systemImage: "square.and.arrow.up")
                    }
                }
            }
            .navigationTitle("Share Options")
            .sheet(isPresented: $showingCustomShare) {
                CustomShareSheet(
                    contentToShare: ShareContent(
                        title: "Demo Content",
                        subtitle: "This is a test of the custom share sheet",
                        iconName: "star.fill",
                        url: URL(string: "https://www.apple.com"),
                        data: nil
                    )
                )
            }
            .sheet(isPresented: $showingNativeShare) {
                NativeShareSheet(
                    items: [
                        "Check out this demo!",
                        URL(string: "https://www.apple.com")!
                    ]
                )
            }
        }
    }
}

#Preview {
    ShareSheetDemo()
}
#endif


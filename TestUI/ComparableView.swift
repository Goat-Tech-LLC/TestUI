import SwiftUI

// MARK: - Comparable View

struct ComparableView: View {
    @State private var currentPage = 0
    @State private var selectedRange = "145 - 155\""

    private let pageCount = 4
    private let comparablePhotos = ComparablePhoto.samples

    private let gridColumns = [
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                heroCarousel
                filterBar
                photoGrid
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 4) {
                    pageIndicator
                    Text("Comparable")
                        .font(.subheadline.weight(.semibold))
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { }) {
                    Image(systemName: "questionmark")
                }
            }
        }
    }

    // MARK: - Page Indicator

    private var pageIndicator: some View {
        HStack(spacing: 6) {
            ForEach(0..<pageCount, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? .primary : Color(.systemGray4))
                    .frame(width: index == currentPage ? 8 : 6, height: index == currentPage ? 8 : 6)
            }
        }
    }

    // MARK: - Hero Carousel

    private var heroCarousel: some View {
        TabView(selection: $currentPage) {
            ForEach(0..<pageCount, id: \.self) { index in
                ZStack(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(Color(.tertiarySystemFill))
                        .overlay {
                            Image(systemName: "photo")
                                .font(.system(size: 40))
                                .foregroundStyle(.gray)
                        }

                    thumbnailStrip
                }
                .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .aspectRatio(408.0 / 350.0, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private var thumbnailStrip: some View {
        HStack(spacing: 8) {
            ForEach(0..<3, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(.white.opacity(0.3))
                    .frame(width: 50, height: 50)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            LinearGradient(
                colors: [.clear, .black.opacity(0.5)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }

    // MARK: - Filter Bar

    private var filterBar: some View {
        HStack(spacing: 12) {
            Menu {
                Button("125 - 135\"") { selectedRange = "125 - 135\"" }
                Button("135 - 145\"") { selectedRange = "135 - 145\"" }
                Button("145 - 155\"") { selectedRange = "145 - 155\"" }
                Button("155 - 165\"") { selectedRange = "155 - 165\"" }
            } label: {
                HStack {
                    Text(selectedRange)
                        .font(.body)
                        .foregroundStyle(.primary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.brandPrimary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color(.separator), lineWidth: 1)
                )
            }

            Button(action: { }) {
                Image(systemName: "line.3.horizontal.decrease")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(.primary)
            }
            .frame(width: 44, height: 44)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color(.separator), lineWidth: 1)
            )
        }
    }

    // MARK: - Photo Grid

    private var photoGrid: some View {
        LazyVGrid(columns: gridColumns, spacing: 4) {
            ForEach(comparablePhotos) { photo in
                photoCard(photo)
            }
        }
    }

    private func photoCard(_ photo: ComparablePhoto) -> some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.tertiarySystemFill))
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    Image(systemName: "photo")
                        .font(.system(size: 20))
                        .foregroundStyle(.gray)
                }

            Text(photo.score)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 6))
                .padding(6)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

// MARK: - Comparable Photo Model

struct ComparablePhoto: Identifiable {
    let id = UUID()
    let score: String

    static let samples: [ComparablePhoto] = (0..<12).map { _ in
        ComparablePhoto(score: "123.5 \"")
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ComparableView()
    }
}

import SwiftUI

// MARK: - Album Model

struct Album: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let coverImageName: String?
    let postCount: Int

    var postLabel: String {
        postCount == 0 ? "No posts" : "\(postCount) post\(postCount == 1 ? "" : "s")"
    }

    var hasPlaceholder: Bool { coverImageName == nil }
}

// MARK: - Add to Album Sheet

struct AddToAlbumSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedAlbum: Album?
    @State private var showNewAlbum = false

    var albums: [Album] = []

    private let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    noAlbumRow

                    if albums.isEmpty {
                        emptyState
                    } else {
                        albumGrid
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Add to Album")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showNewAlbum = true }) {
                        Image(systemName: "plus")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.brandPrimary)
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.hidden)
        // OBADIAH: This is the magic line! .scrolls makes the sheet content scroll
        // FIRST before the sheet drag gesture kicks in. Without this, dragging
        // anywhere on the sheet resizes it instead of scrolling the album grid.
        // Only the drag indicator (handle) will resize the sheet now.
        .presentationContentInteraction(.scrolls)
        .presentationBackground(Color(.systemBackground))
        .sheet(isPresented: $showNewAlbum) {
            NewAlbumSheet()
                .presentationDetents([.large])
                .interactiveDismissDisabled()
                .presentationBackground(Color(.systemBackground))
        }
    }

    // MARK: - No Album Row

    private var noAlbumRow: some View {
        Button(action: { selectedAlbum = nil }) {
            HStack(spacing: 12) {
                Image(systemName: "rectangle.stack")
                    .font(.body)
                    .foregroundStyle(Color.brandPrimary)
                Text("No Album")
                    .font(.body)
                    .foregroundStyle(Color.brandPrimary)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.brandPrimary.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: "folder.fill")
                .font(.title2)
                .foregroundStyle(.tertiary)

            Spacer()
                .frame(height: 16)

            Text("No Albums Yet")
                .font(.body.weight(.semibold))
                .foregroundStyle(.primary)

            Text("Albums you create will appear here. Tap + to get started.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(.background.secondary)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    // MARK: - Album Grid

    private var albumGrid: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(albums, id: \Album.id) { album in
                albumCard(album)
            }
        }
    }

    private func albumCard(_ album: Album) -> some View {
        Button(action: { selectedAlbum = album }) {
            ZStack(alignment: .bottom) {
                // Cover image or placeholder
                if let imageName = album.coverImageName {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 120)
                        .clipped()
                } else {
                    ZStack {
                        Rectangle()
                            .fill(Color(.systemFill))
                        Image(systemName: "photo")
                            .font(.title2)
                            .foregroundStyle(.gray)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 120)
                }

                // Glass Metalabel
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(album.name)
                            .font(.footnote.weight(.semibold))
                            .lineLimit(1)
                        Text(album.postLabel)
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 12))
                .padding(5)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .buttonStyle(.plain)
    }
}

// MARK: - Previews

#Preview("Empty State") {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            AddToAlbumSheet()
        }
}

#Preview("With Albums") {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            AddToAlbumSheet(albums: [
                Album(name: "Wife", coverImageName: nil, postCount: 1),
                Album(name: "Mountain Game Trails 2023", coverImageName: nil, postCount: 0),
                Album(name: "Ohio Trip 23", coverImageName: nil, postCount: 5),
                Album(name: "Canada 24", coverImageName: nil, postCount: 2),
                Album(name: "Mexico 2025", coverImageName: nil, postCount: 2),
                Album(name: "Pennsylvania 26", coverImageName: nil, postCount: 5),
            ])
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
}

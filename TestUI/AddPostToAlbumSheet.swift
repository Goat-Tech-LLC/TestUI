import SwiftUI

// MARK: - Unassigned Post Model

struct UnassignedPost: Identifiable {
    let id = UUID()
    let score: String

    static let samples: [UnassignedPost] = [
        UnassignedPost(score: "138 \""),
        UnassignedPost(score: "126 \""),
        UnassignedPost(score: "16 \""),
        UnassignedPost(score: "159 \""),
        UnassignedPost(score: "208 \""),
        UnassignedPost(score: "35 \""),
    ]
}

// MARK: - Add Post to Album Sheet

struct AddPostToAlbumSheet: View {
    @Environment(\.dismiss) private var dismiss
    let posts: [UnassignedPost]

    private let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    if posts.isEmpty {
                        emptyState
                    } else {
                        postGrid
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .navigationTitle("Add to Album")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.hidden)
        .presentationContentInteraction(.scrolls)
        .presentationBackground(.background)
    }

    // MARK: - Post Grid

    private var postGrid: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("POSTS WITHOUT ALBUMS")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.secondary)

            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(posts) { post in
                    postThumbnail(post)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }

    private func postThumbnail(_ post: UnassignedPost) -> some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle()
                .fill(.gray.opacity(0.3))
                .aspectRatio(1, contentMode: .fill)
                .overlay {
                    Image(systemName: "photo")
                        .font(.system(size: 16))
                        .foregroundStyle(.quaternary)
                }

            Text(post.score)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 10))
                .padding(6)
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("POSTS WITHOUT ALBUMS")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 32) {
                Image(systemName: "photo.stack")
                    .font(.title)
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 4) {
                    Text("No Posts")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.primary)
                    Text("Posts you create will appear here.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(Color(.systemFill).opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        }
    }
}

// MARK: - Previews

#Preview("With Posts") {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            AddPostToAlbumSheet(posts: UnassignedPost.samples)
        }
}

#Preview("Empty State") {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            AddPostToAlbumSheet(posts: [])
        }
}

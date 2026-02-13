import SwiftUI

// MARK: - Album Post Model

struct AlbumPost: Identifiable {
    let id = UUID()
    let title: String
    let location: String
    let itemCount: Int
    let category: String
    let score: String

    static let samples: [AlbumPost] = [
        AlbumPost(title: "Cornfield Giant", location: "Macon County, IL", itemCount: 3, category: "HARVEST", score: "138 \""),
        AlbumPost(title: "Trail Cam Buck", location: "Renfrew County, ON", itemCount: 4, category: "FIELD JUDGE", score: "126 \""),
        AlbumPost(title: "Red Stag Down", location: "Unit 12A, AZ", itemCount: 6, category: "HARVEST", score: "16 \""),
        AlbumPost(title: "Food Plot Stud", location: "Buffalo County, WI", itemCount: 2, category: "HARVEST", score: "128 \""),
        AlbumPost(title: "Big Score", location: "Kaibab Plateau", itemCount: 5, category: "HARVEST", score: "123.5 \""),
        AlbumPost(title: "Big Score", location: "Kaibab Plateau", itemCount: 5, category: "HARVEST", score: "165 \""),
    ]
}

// MARK: - Album Detail View

struct AlbumDetailView: View {
    let albumTitle: String
    let postCount: Int
    let posts: [AlbumPost]

    private let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 2) {
                heroSection
                gridSection
            }
        }
        .ignoresSafeArea(edges: .top)
        .toolbar {
            // First trailing pill: plus
            

            // Second trailing pill: ellipsis
            ToolbarItem() {
                Button {
                    // ellipsis
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
            
            ToolbarSpacer(.fixed)
            
            ToolbarItem() {
                Button {
                    // plus
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }

    // MARK: - Hero Section

    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle()
                .fill(.gray.opacity(0.3))
                .frame(height: 440)
                .overlay {
                    Image(systemName: "photo")
                        .font(.system(size: 48))
                        .foregroundStyle(.quaternary)
                }

            LinearGradient(
                colors: [.clear, .black.opacity(0.5)],
                startPoint: .center,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 8) {
                Text(albumTitle)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                Text("\(postCount) posts")
                    .font(.subheadline)
                    .foregroundStyle(Color(white: 0.78))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .frame(height: 440)
    }

    // MARK: - Grid Section

    private var gridSection: some View {
        LazyVGrid(columns: columns, spacing: 2) {
            ForEach(posts) { post in
                AlbumCardView(post: post)
            }
        }
    }
}

// MARK: - Album Card View

struct AlbumCardView: View {
    let post: AlbumPost

    var body: some View {
        ZStack {
            // Photo placeholder
            Rectangle()
                .fill(.gray.opacity(0.3))
                .overlay {
                    Image(systemName: "photo")
                        .font(.system(size: 24))
                        .foregroundStyle(.quaternary)
                }

            // Bottom gradient for text legibility
            VStack {
                Spacer()
                LinearGradient(
                    colors: [.clear, .black.opacity(0.7)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 120)
            }

            // Content overlay
            VStack(alignment: .leading) {
                // Score badge — top right
                HStack {
                    Spacer()
                    scoreBadge
                }
                .padding(.top, 6)
                .padding(.trailing, 10)

                Spacer()

                // Bottom metadata
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "location")
                            .font(.system(size: 11))
                        Text(post.location)
                            .font(.footnote)
                    }
                    .foregroundStyle(Color(white: 0.78))

                    HStack(alignment: .bottom, spacing: 10) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(post.title)
                                .font(.headline)
                                .foregroundStyle(.white)
                                .lineLimit(2)
                            Text("\(post.itemCount) items")
                                .font(.footnote)
                                .foregroundStyle(Color(white: 0.78))
                        }

                        Spacer()

                        Text(post.category)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Color.brandPrimary)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 6)
            }
        }
        .aspectRatio(0.82, contentMode: .fill)
        .clipped()
    }

    // MARK: - Score Badge

    private var scoreBadge: some View {
        Text(post.score)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .glassEffect(.regular.interactive(), in: Capsule())
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        AlbumDetailView(
            albumTitle: "Pennsylvania 26",
            postCount: 12,
            posts: AlbumPost.samples
        )
    }
}

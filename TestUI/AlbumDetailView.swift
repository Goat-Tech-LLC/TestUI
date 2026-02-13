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
    
    @State private var showMetalabel = false
    @State private var showAddPostSheet = false
    @State private var showDeleteAlert = false
    
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
        .onScrollGeometryChange(for: Bool.self) { geo in
            geo.contentOffset.y > 300
        } action: { _, shouldShow in
            withAnimation(.easeInOut(duration: 0.2)) {
                showMetalabel = shouldShow
            }
        }
        .ignoresSafeArea(edges: .top)
        .toolbar {
            ToolbarItem(placement: .principal) {
                    VStack(spacing: 2) {
                        Text(albumTitle)
                            .font(.callout.weight(.semibold))
                        Text("\(postCount) posts")
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 4)
                    .glassEffect(.regular.interactive(), in: Capsule())
                    .opacity(showMetalabel ? 1 : 0)
                    .frame(maxWidth: 157)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        // rename action
                    } label: {
                        Label("Rename Album", systemImage: "square.and.pencil")
                    }
                    Divider()
                    Button(role: .destructive) {
                        showDeleteAlert = true
                    } label: {
                        Label("Delete Album", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
            ToolbarSpacer(.flexible, placement: .bottomBar)
            ToolbarItem(placement: .bottomBar) {
                Button {
                    showAddPostSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddPostSheet) {
            AddPostToAlbumSheet(posts: UnassignedPost.samples)
        }
        .alert("Delete Album?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                // delete action
            }
        } message: {
            Text("Deleting this album will remove all posts from it.")
        }
    }
    
    // MARK: - Hero Section
    
    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle()
                .fill(Color(.systemGray3))
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
                if posts.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "photo.on.rectangle")
                            .font(.subheadline)
                        Text("No posts")
                            .font(.subheadline)
                    }
                    .foregroundStyle(.white)
                } else {
                    Label("\(postCount) posts", systemImage: "photo.stack.fill")
                        .font(.subheadline)
                        .foregroundStyle(.white)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .opacity(showMetalabel ? 0 : 1)
        }
        .frame(height: 440)
    }
    
    // MARK: - Grid Section

    private var gridSection: some View {
        Group {
            if posts.isEmpty {
                emptyGridPlaceholder
            } else {
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(posts) { post in
                        AlbumCardView(post: post)
                    }
                }
            }
        }
    }

    // MARK: - Empty Grid Placeholder

    private var emptyGridPlaceholder: some View {
        HStack(spacing: 2) {
            Button {
                showAddPostSheet = true
            } label: {
                VStack(spacing: 8) {
                    Image(systemName: "photo.badge.plus")
                        .font(.title2)
                        .foregroundStyle(Color.brandPrimary)
                    Text("Add Post")
                        .font(.body.weight(.medium))
                        .foregroundStyle(.primary)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .background(Color(.systemGray6))
            }
            .buttonStyle(.plain)

            // Empty trailing cell to match 2-column grid
            Color.clear
                .frame(maxWidth: .infinity)
                .frame(height: 200)
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
                .fill(.gray.secondary)
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
                .padding(.top, 10)
                .padding(.trailing, 10)
                
                Spacer()
                
                // Bottom metadata
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle")
                            .font(.subheadline)
                        Text(post.location)
                            .font(.footnote)
                    }
                    .foregroundStyle(Color(white: 0.78))
                    
                    HStack(alignment: .bottom, spacing: 10) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(post.title)
                                .font(.headline)
                                .foregroundStyle(.white)
                                .lineLimit(3)
                            Text("\(post.itemCount) items")
                                .font(.headline)
                                .foregroundStyle(Color(white: 0.78))
                        }
                        
                        Spacer()
                        
                        Text(post.category)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Color.brandPrimary)
                            .multilineTextAlignment(.trailing)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 6)
            }
        }
        .aspectRatio(0.82, contentMode: .fill)
    }
    
    // MARK: - Score Badge
    
    private var scoreBadge: some View {
        Text(post.score)
            .font(.title3.weight(.semibold))
            .foregroundStyle(.primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Preview

#Preview("With Posts") {
    NavigationStack {
        List {
            NavigationLink("View Album") {
                AlbumDetailView(
                    albumTitle: "Pennsylvania 26",
                    postCount: 12,
                    posts: AlbumPost.samples
                )
            }
        }
        .navigationTitle("Albums")
    }
}

#Preview("Empty Album") {
    NavigationStack {
        AlbumDetailView(
            albumTitle: "Pennsylvania 26",
            postCount: 0,
            posts: []
        )
    }
}

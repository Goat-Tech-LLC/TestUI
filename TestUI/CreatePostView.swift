import SwiftUI
//
//// MARK: - Brand Colors (only non-system colors)
//
extension Color {
    static let brandPrimary = Color(red: 190/255, green: 132/255, blue: 93/255) // #BE845D
}
//
//// MARK: - Create Post View
//
//struct CreatePostView: View {
//    @State private var caption = ""
//    @State private var showVisibilitySheet = false
//    @State private var selectedVisibility: PostVisibility = .everyone
//    @State private var guessTheScore = true
//    @State private var showAlbumSheet = false
//    @State private var selectedAlbumName: String? = nil
//
//    let images: [String]
//    let linkedScore: String?
//    
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 16) {
//                photoContainer
//                captionField
//                metadataSection
//            }
//            .padding(.horizontal, 16)
//            .padding(.top, 16)
//            .padding(.bottom, 32)
//        }
//        .background(Color(.systemGroupedBackground))
//        .navigationTitle("Create Post")
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .topBarTrailing) {
//                Button(action: { }) {
//                    Image(systemName: "questionmark")
//                        .font(.system(size: 17, weight: .semibold))
//                }
//            }
//        }
//        .toolbar {
//            ToolbarItem(placement: .bottomBar) {
//                    shareButton
//                    .frame(maxWidth: .infinity)
//
//            }
//        }
//        .sheet(isPresented: $showVisibilitySheet) {
//            VisibilitySheet(selection: $selectedVisibility)
//                .presentationDetents([.height(390)])
//                .presentationBackground(Color(uiColor: .systemBackground))
//        }
//        .sheet(isPresented: $showAlbumSheet) {
//            AlbumSheet(selectedAlbumName: $selectedAlbumName)
//                .presentationDetents([.medium, .large])
//        }
//    }
//    
//    // MARK: - Photo Container
//    
//    private var photoContainer: some View {
//        ZStack(alignment: .topTrailing) {
//            RoundedRectangle(cornerRadius: 22, style: .continuous)
//                .fill(Color(.tertiarySystemFill))
//                .aspectRatio(408.0 / 368.0, contentMode: .fit)
//                .overlay {
//                    if images.isEmpty {
//                        VStack(spacing: 8) {
//                            Image(systemName: "photo.badge.plus")
//                                .font(.system(size: 32))
//                            Text("Add Photos")
//                                .font(.footnote)
//                        }
//                        .foregroundStyle(.secondary)
//                    }
//                }
//                .overlay(alignment: .bottom) {
//                    if !images.isEmpty {
//                        thumbnailStrip
//                    }
//                }
//            
//            if !images.isEmpty {
//                Button(action: { }) {
//                    Image(systemName: "trash")
//                        .font(.system(size: 17, weight: .semibold))
//                }
//                .frame(width: 44, height: 44)
//                .glassEffect(.regular.interactive(), in: .circle)
//                .padding(10)
//            }
//        }
//    }
//    
//    private var thumbnailStrip: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack(spacing: 10) {
//                ForEach(0..<7, id: \.self) { _ in
//                    RoundedRectangle(cornerRadius: 12, style: .continuous)
//                        .fill(.gray.opacity(0.3))
//                        .frame(width: 50, height: 50)
//                }
//                
//                Button(action: { }) {
//                    Image(systemName: "photo.badge.plus")
//                        .font(.system(size: 17))
//                        .foregroundStyle(.secondary)
//                        .frame(width: 50, height: 50)
//                }
//                .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 12))
//            }
//            .padding(.horizontal, 16)
//        }
//        .frame(height: 70)
//        .background(
//            LinearGradient(
//                colors: [.clear, .black.opacity(0.5)],
//                startPoint: .top,
//                endPoint: .bottom
//            )
//        )
//        .clipShape(
//            UnevenRoundedRectangle(
//                bottomLeadingRadius: 22,
//                bottomTrailingRadius: 22,
//                style: .continuous
//            )
//        )
//    }
//    
//    // MARK: - Caption Field
//    
//    private var captionField: some View {
//        VStack(alignment: .trailing, spacing: 8) {
//            TextField("Add a caption...", text: $caption, axis: .vertical)
//                .font(.body)
//                .lineLimit(3...6)
//                .frame(maxWidth: .infinity, alignment: .leading)
//            
//            Text("\(max(0, 1000 - caption.count)) char left")
//                .font(.footnote)
//                .foregroundStyle(.tertiary)
//        }
//        .padding(.horizontal, 16)
//        .padding(.vertical, 8)
//        .background(Color(.secondarySystemGroupedBackground))
//        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
//    }
//    
//    // MARK: - Metadata Section
//    
//    private var metadataSection: some View {
//        VStack(spacing: 0) {
//            MetadataRow(icon: "location", title: "Location", detail: "No location") {
//                // open location picker
//            }
//            
//            Divider().padding(.leading, 42)
//            
//            MetadataRow(icon: "eye", title: "Visibility", detail: selectedVisibility.label) {
//                showVisibilitySheet = true
//            }
//            
//            Divider().padding(.leading, 42)
//            
//            MetadataRow(icon: "photo.on.rectangle", title: "Album", detail: selectedAlbumName ?? "None") {
//                showAlbumSheet = true
//            }
//            
//            Divider().padding(.leading, 42)
//            
//            linkedScoreRow
//            
//            Divider().padding(.leading, 42)
//            
//            guessTheScoreRow
//        }
//        .padding(.horizontal, 16)
//        .background(Color(.secondarySystemGroupedBackground))
//        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
//    }
//    
//    private var linkedScoreRow: some View {
//        HStack {
//            Image(systemName: "tag")
//                .font(.body)
//                .foregroundStyle(.secondary)
//                .frame(width: 25)
//            
//            Text("Linked Score")
//                .font(.body)
//            
//            Spacer()
//            
//            if let score = linkedScore {
//                HStack(spacing: 5) {
//                    Text(score)
//                        .font(.body.weight(.semibold))
//                    Image(systemName: "checkmark")
//                        .font(.system(size: 14, weight: .semibold))
//                }
//                .foregroundStyle(Color.brandPrimary)
//                .padding(.horizontal, 11)
//                .padding(.vertical, 6)
//                .background(Color.brandPrimary.opacity(0.15))
//                .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
//            }
//        }
//        .frame(height: 52)
//    }
//    
//    private var guessTheScoreRow: some View {
//        HStack {
//            Image(systemName: "trophy")
//                .font(.body)
//                .foregroundStyle(.secondary)
//                .frame(width: 25)
//            
//            Text("Guess the Score")
//                .font(.body)
//            
//            Spacer()
//            
//            Toggle("", isOn: $guessTheScore)
//                .labelsHidden()
//                .tint(.green)
//        }
//        .frame(height: 52)
//    }
//    
//    // MARK: - Share Button
//    
//    private var shareButton: some View {
//        Button(action: { }) {
//            Text("Share")
//                .font(.body.weight(.semibold))
//                .foregroundStyle(.white)
//                .padding(.vertical, 14)
//        }
//        .buttonStyle(.glassProminent)
//        .tint(Color.brandPrimary)
//    }
//}
//
//// MARK: - Metadata Row
//
//struct MetadataRow: View {
//    let icon: String
//    let title: String
//    let detail: String
//    var action: () -> Void = {}
//    
//    var body: some View {
//        Button(action: action) {
//            HStack {
//                Image(systemName: icon)
//                    .font(.body)
//                    .foregroundStyle(.secondary)
//                    .frame(width: 25)
//                
//                Text(title)
//                    .font(.body)
//                    .foregroundStyle(.primary)
//                
//                Spacer()
//                
//                Text(detail)
//                    .font(.body)
//                    .foregroundStyle(.secondary)
//                
//                Image(systemName: "chevron.right")
//                    .font(.system(size: 14, weight: .semibold))
//                    .foregroundStyle(.tertiary)
//            }
//        }
//        .frame(height: 52)
//    }
//}
//
//// MARK: - Visibility Types
//
//enum PostVisibility: String, CaseIterable {
//    case everyone
//    case unlisted
//    case `private`
//    
//    var label: String {
//        switch self {
//        case .everyone: "Public"
//        case .unlisted: "Unlisted"
//        case .private: "Private"
//        }
//    }
//    
//    var icon: String {
//        switch self {
//        case .everyone: "globe"
//        case .unlisted: "tag"
//        case .private: "lock"
//        }
//    }
//    
//    var subtitle: String {
//        switch self {
//        case .everyone: "Anyone on HornScore can see this post"
//        case .unlisted: "Only those you share the link with will be able to see this"
//        case .private: "Private to your profile only"
//        }
//    }
//}
//
//// MARK: - Visibility Sheet
//
//struct VisibilitySheet: View {
//    @Binding var selection: PostVisibility
//    @Environment(\.dismiss) private var dismiss
//    
//    var body: some View {
//        NavigationStack {
//                VStack(alignment: .leading, spacing: 12) {
//                    VStack(spacing: 12) {
//                        ForEach(PostVisibility.allCases, id: \.self) { option in
//                            visibilityOption(option)
//                        }
//                    }
//                    
//                    Divider()
//                    
//                    HStack(alignment: .top, spacing: 12) {
//                        Image(systemName: "info.circle")
//                            .font(.footnote.weight(.semibold))
//                            .foregroundStyle(.secondary)
//                        
//                        Text("You can change the visibility of your post at any time from your profile")
//                            .font(.footnote)
//                            .foregroundStyle(.secondary)
//                            .lineLimit(nil)
//                            .fixedSize(horizontal: false, vertical: true)
//                    }
//                    .padding(.top, 12)
//                }
//                .padding(.bottom, 64)
//                .padding(.horizontal, 16)
//                .toolbar {
//                    ToolbarItem(placement: .topBarLeading) {
//                        Button(action: { dismiss() }) {
//                            Image(systemName: "xmark")
//                                .font(.system(size: 17, weight: .semibold))
//                        }
//                    }
//                    ToolbarItem(placement: .principal) {
//                        Text("Visibility")
//                            .font(.title3)
//                            .fontWeight(.semibold)
//                    }
//                    ToolbarItem(placement: .confirmationAction) {
//                        Button(role: .confirm, action: { dismiss() }) {
//                            Text("Done")
//                                .font(.body.weight(.medium))
//                                .foregroundStyle(.white)
//                        }
//                        .buttonStyle(.borderedProminent)
//                        .tint(Color.brandPrimary)
//                    }
//                }
//        }
//    }
//    
//    // MARK: - Visibility Option
//    
//    private func visibilityOption(_ option: PostVisibility) -> some View {
//        Button(action: { selection = option }) {
//            HStack(spacing: 10) {
//                Image(systemName: option.icon)
//                    .font(.title3)
//                    .foregroundStyle(selection == option ? Color.brandPrimary : .secondary)
//                    .frame(width: 44, height: 44)
//                    .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 12))
//                
//                VStack(alignment: .leading, spacing: 2) {
//                    Text(option.label)
//                        .font(.body.weight(.semibold))
//                        .foregroundStyle(.primary)
//                    
//                    Text(option.subtitle)
//                        .font(.footnote)
//                        .foregroundStyle(.secondary)
//                        .multilineTextAlignment(.leading)
//                        .lineLimit(nil)
//                        .fixedSize(horizontal: false, vertical: true)
//                }
//                
//                Spacer()
//                
//                Group {
//                    if selection == option {
//                        Image(systemName: "checkmark.circle.fill")
//                            .font(.system(size: 22))
//                            .foregroundStyle(Color.brandPrimary)
//                    } else {
//                        Circle()
//                            .stroke(.tertiary, lineWidth: 1.5)
//                            .frame(width: 22, height: 22)
//                    }
//                }
//                .frame(width: 22, height: 22)
//            }
//            .padding(.vertical, 4)
//            .padding(.trailing, 16)
//            .contentShape(Rectangle())
//        }
//        .buttonStyle(.plain)
//    }
//}
//
//// MARK: - Album Model
//
//struct Album: Identifiable {
//    let id = UUID()
//    let name: String
//    let postCount: Int
//    let hasCoverImage: Bool
//
//    static let samples: [Album] = [
//        Album(name: "Wife", postCount: 1, hasCoverImage: true),
//        Album(name: "Mountain Game Trails 2023", postCount: 0, hasCoverImage: false),
//        Album(name: "Ohio Trip 23", postCount: 5, hasCoverImage: true),
//        Album(name: "Canada 24", postCount: 2, hasCoverImage: true),
//        Album(name: "Mexico 2025", postCount: 2, hasCoverImage: true),
//        Album(name: "Pennsylvania 26", postCount: 5, hasCoverImage: true),
//    ]
//}
//
//// MARK: - Album Sheet
//
//struct AlbumSheet: View {
//    @Binding var selectedAlbumName: String?
//    @Environment(\.dismiss) private var dismiss
//
//    private let albums = Album.samples
//    private let columns = [
//        GridItem(.flexible(), spacing: 12),
//        GridItem(.flexible(), spacing: 12)
//    ]
//
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                VStack(spacing: 0) {
//                    noAlbumOption
//
//                    Divider()
//                        .padding(.vertical, 10)
//
//                    albumGrid
//                }
//                .padding(.horizontal, 16)
//                .padding(.bottom, 64)
//            }
//            .toolbar {
//                ToolbarItem(placement: .topBarLeading) {
//                    Button(action: { dismiss() }) {
//                        Image(systemName: "xmark")
//                    }
//                }
//                ToolbarItem(placement: .principal) {
//                    Text("Add to Album")
//                        .font(.title3)
//                        .fontWeight(.semibold)
//                }
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button(action: { }) {
//                        Image(systemName: "plus")
//                    }
//                    .buttonStyle(.borderedProminent)
//                    .tint(.brandPrimary)
//                }
//            }
//        }
//    }
//
//    // MARK: - No Album Option
//
//    private var noAlbumOption: some View {
//        Button(action: {
//            selectedAlbumName = nil
//            dismiss()
//        }) {
//            HStack(spacing: 16) {
//                Image(systemName: "rectangle.stack")
//                    .font(.title3.weight(.semibold))
//                    .foregroundStyle(Color.brandPrimary)
//
//                Text("No Album")
//                    .font(.body.weight(.semibold))
//                    .foregroundStyle(Color.brandPrimary)
//
//                Spacer()
//            }
//            .padding(.horizontal, 16)
//            .frame(height: 52)
//            .background(Color.brandPrimary.opacity(0.3))
//            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
//        }
//        .buttonStyle(.plain)
//    }
//
//    // MARK: - Album Grid
//
//    private var albumGrid: some View {
//        LazyVGrid(columns: columns, spacing: 12) {
//            ForEach(albums) { album in
//                albumCard(album)
//            }
//        }
//    }
//
//    private func albumCard(_ album: Album) -> some View {
//        Button(action: {
//            selectedAlbumName = album.name
//            dismiss()
//        }) {
//            ZStack(alignment: .bottomLeading) {
//                RoundedRectangle(cornerRadius: 12, style: .continuous)
//                    .fill(Color(.tertiarySystemFill))
//                    .overlay {
//                        if !album.hasCoverImage {
//                            Image(systemName: "photo")
//                                .font(.system(size: 24))
//                                .foregroundStyle(.gray)
//                        }
//                    }
//
//                VStack(alignment: .leading, spacing: 4) {
//                    Text(album.name)
//                        .font(.footnote.weight(.semibold))
//                        .foregroundStyle(.primary)
//                        .lineLimit(1)
//
//                    Text(album.postCount == 0 ? "No posts" : "\(album.postCount) post\(album.postCount == 1 ? "" : "s")")
//                        .font(.caption.weight(.medium))
//                        .foregroundStyle(.secondary)
//                }
//                .padding(.horizontal, 12)
//                .padding(.vertical, 8)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
//                .padding(5)
//            }
//            .frame(minHeight: 133)
//            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
//        }
//        .buttonStyle(.plain)
//    }
//}
//
//// MARK: - Preview
//
//#Preview {
//    NavigationStack {
//        CreatePostView(
//            images: [],
//            linkedScore: "145 - 155\""
//        )
//    }
//}

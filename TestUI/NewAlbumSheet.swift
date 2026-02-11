import SwiftUI

// MARK: - New Album Sheet

struct NewAlbumSheet: View {
    @State private var albumName = ""
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isNameFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                coverPhotoSection
                nameField
                    .padding(.top, 32)
                Spacer()
            }
            .padding(.horizontal, 16)
            .background(Color(.systemGroupedBackground))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("New Album")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(role: .confirm, action: {
                        // Create album
                        dismiss()
                    }) {
                        Text("Create")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.brandPrimary)
                    .disabled(albumName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear {
                isNameFocused = true
            }
        }
    }

    // MARK: - Cover Photo

    private var coverPhotoSection: some View {
        VStack(spacing: 12) {
            Button(action: {
                // Open photo picker
            }) {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color(.tertiarySystemFill))
                    .frame(width: 230, height: 230)
                    .overlay {
                        Image(systemName: "photo.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(.gray)
                    }
            }
            .buttonStyle(.plain)

            Button(action: {
                // Open photo picker
            }) {
                Text("Add Cover Photo")
                    .font(.subheadline)
                    .foregroundStyle(Color.brandPrimary)
            }
            .buttonStyle(.bordered)
        }
    }

    // MARK: - Name Field

    private var nameField: some View {
        TextField("New Album Name", text: $albumName)
            .font(.body)
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
            .focused($isNameFocused)
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var isPresented = true
    VStack {
        
    }
    .sheet(isPresented: $isPresented) {
        NewAlbumSheet()
            .presentationDetents([.large])
            .interactiveDismissDisabled()
            .presentationBackground(Color(uiColor: .systemBackground))
    }
}

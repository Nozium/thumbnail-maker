import SwiftUI
#if os(iOS)
import PhotosUI
#endif

struct ContentView: View {
    @Bindable var project: ThumbnailProject

    #if os(iOS)
    @State private var showImagePicker = false
    @State private var selectedPhoto: PhotosPickerItem?
    #endif

    var body: some View {
        #if os(macOS)
        HSplitView {
            CanvasPreviewView(project: project)
                .frame(minWidth: 500)

            ScrollView {
                SidebarView(project: project)
                    .padding()
            }
            .frame(width: 300)
            .background(.background)
        }
        #else
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Preview area
                    CanvasPreviewView(project: project)
                        .frame(height: 300)
                        .onTapGesture {
                            if !project.hasSourceImage {
                                showImagePicker = true
                            }
                        }

                    // Controls
                    SidebarView(project: project)
                        .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Thumbnail Maker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        if let image = ClipboardService.shared.readImage() {
                            project.sourceImage = image
                        } else {
                            showImagePicker = true
                        }
                    } label: {
                        Image(systemName: "photo.badge.plus")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        Image(systemName: "photo.on.rectangle")
                    }
                }
            }
            .onChange(of: selectedPhoto) { _, newValue in
                loadPhoto(from: newValue)
            }
            .photosPicker(isPresented: $showImagePicker, selection: $selectedPhoto, matching: .images)
        }
        #endif
    }

    #if os(iOS)
    private func loadPhoto(from item: PhotosPickerItem?) {
        guard let item else { return }
        item.loadTransferable(type: Data.self) { result in
            if case .success(let data) = result, let data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    project.sourceImage = image
                }
            }
        }
    }
    #endif
}

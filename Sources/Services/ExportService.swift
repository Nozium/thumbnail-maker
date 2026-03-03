#if os(macOS)
import AppKit
import UniformTypeIdentifiers

enum ExportService {
    @MainActor
    static func savePNG(image: PlatformImage, suggestedName: String) {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.png]
        panel.nameFieldStringValue = "\(suggestedName).png"
        panel.canCreateDirectories = true

        guard panel.runModal() == .OK, let url = panel.url else { return }

        guard let tiffData = image.tiffRepresentation,
              let bitmapRep = NSBitmapImageRep(data: tiffData),
              let pngData = bitmapRep.representation(using: .png, properties: [:])
        else { return }

        try? pngData.write(to: url)
    }
}
#endif

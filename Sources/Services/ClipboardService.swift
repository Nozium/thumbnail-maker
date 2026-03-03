#if os(macOS)
import AppKit
#else
import UIKit
#endif

final class ClipboardService {
    static let shared = ClipboardService()

    func readImage() -> PlatformImage? {
        #if os(macOS)
        let pasteboard = NSPasteboard.general
        if let images = pasteboard.readObjects(forClasses: [NSImage.self], options: nil),
           let image = images.first as? NSImage {
            return image
        }
        guard let items = pasteboard.pasteboardItems else { return nil }
        for item in items {
            for type in [NSPasteboard.PasteboardType.png, .tiff] {
                if let data = item.data(forType: type),
                   let image = NSImage(data: data) {
                    return image
                }
            }
        }
        return nil
        #else
        return UIPasteboard.general.image
        #endif
    }

    func writeImage(_ image: PlatformImage) {
        #if os(macOS)
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.writeObjects([image])
        #else
        UIPasteboard.general.image = image
        #endif
    }
}

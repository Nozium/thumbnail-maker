import SwiftUI

#if os(macOS)
import AppKit
#endif

@main
struct ThumbnailMakerApp: App {
    @State private var project = ThumbnailProject()

    #if os(macOS)
    @State private var monitorInstalled = false
    #endif

    var body: some Scene {
        #if os(macOS)
        Window("Thumbnail Maker", id: "main") {
            ContentView(project: project)
                .onAppear {
                    if !monitorInstalled {
                        monitorInstalled = true
                        setupKeyboardMonitor()
                    }
                }
        }
        .defaultSize(width: 1100, height: 750)
        #else
        WindowGroup {
            ContentView(project: project)
        }
        #endif
    }

    #if os(macOS)
    private func setupKeyboardMonitor() {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            guard event.modifierFlags.contains(.command) else { return event }

            if let firstResponder = NSApp.keyWindow?.firstResponder,
               firstResponder is NSTextView || firstResponder is NSTextField {
                return event
            }

            switch event.charactersIgnoringModifiers {
            case "v":
                if let image = ClipboardService.shared.readImage() {
                    project.sourceImage = image
                    return nil
                }
                return event
            case "c":
                if project.hasSourceImage,
                   let image = ImageRenderService.render(project: project) {
                    ClipboardService.shared.writeImage(image)
                    return nil
                }
                return event
            default:
                return event
            }
        }
    }
    #endif
}

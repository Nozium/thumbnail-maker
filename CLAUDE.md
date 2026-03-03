# CLAUDE.md - Thumbnail Maker

## Project Overview

Native SwiftUI thumbnail maker app for macOS and iOS. Users paste iPhone screenshots and create social media thumbnails with backgrounds and text overlays.

## Tech Stack

- **Language**: Swift 5.10
- **UI**: SwiftUI (Observation framework, @Observable)
- **Platforms**: macOS 14+ / iOS 17+
- **Build**: Swift Package Manager (Package.swift)
- **No external dependencies**

## Architecture

- **@Observable models** (Observation framework) for reactive state
- **ThumbnailCanvasView** is the single renderable view used for both live preview AND final export (WYSIWYG)
- **ImageRenderer** captures the SwiftUI view at exact pixel dimensions (scale = 1.0)
- **Platform-specific code** uses `#if os(macOS)` / `#if os(iOS)` conditional compilation
- **PlatformImage** typealias bridges NSImage (macOS) and UIImage (iOS)

## Key Files

| File | Purpose |
|------|---------|
| `Sources/Models/ThumbnailProject.swift` | Central @Observable model, single source of truth |
| `Sources/Views/Canvas/ThumbnailCanvasView.swift` | Core rendering view (preview + export) |
| `Sources/Services/ImageRenderService.swift` | SwiftUI → image at exact pixel dimensions |
| `Sources/Services/ClipboardService.swift` | Clipboard read/write (NSPasteboard / UIPasteboard) |
| `Sources/ThumbnailMakerApp.swift` | Entry point, keyboard shortcuts (macOS) |

## Platform Sizes

- X: 1080x1080 (square)
- note.com: 1280x670
- LinkedIn: 1200x627

## Build Commands

```bash
swift build          # Build for macOS
./build.sh           # Build + create .app bundle
open ThumbnailMaker.app  # Run
```

## Conventions

- Models use `@Observable` (not ObservableObject/@Published)
- Views use `@Bindable` for observable object bindings
- Services are singletons (`ClipboardService.shared`) or enum with static methods
- Cross-platform code uses `PlatformImage` typealias and `Image(platformImage:)`
- macOS-specific: `#if os(macOS)` guards around AppKit imports and APIs
- iPhone corner radius: `width * 0.141` ratio (matches real device curvature)

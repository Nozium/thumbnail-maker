#if os(macOS)
import SwiftUI
import AVKit

/// Looping video player for preview within the canvas
struct VideoPlayerView: NSViewRepresentable {
    let url: URL

    func makeNSView(context: Context) -> AVPlayerView {
        let player = AVPlayer(url: url)
        player.isMuted = true

        let view = AVPlayerView()
        view.player = player
        view.controlsStyle = .none
        view.videoGravity = .resizeAspectFill

        // Loop playback
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { _ in
            player.seek(to: .zero)
            player.play()
        }

        player.play()
        return view
    }

    func updateNSView(_ nsView: AVPlayerView, context: Context) {
        // Only replace player if URL changed
        if let currentURL = (nsView.player?.currentItem?.asset as? AVURLAsset)?.url,
           currentURL == url {
            return
        }
        let player = AVPlayer(url: url)
        player.isMuted = true
        nsView.player = player

        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { _ in
            player.seek(to: .zero)
            player.play()
        }

        player.play()
    }
}
#endif

import Foundation
import UIKit

@objc public class PrivacyScreen: NSObject {
    private var observers: [NSObjectProtocol] = []
    private var windowProvider: (() -> UIWindow?)?
    private weak var overlayView: UIView?
    private(set) var isEnabled = false

    deinit {
        stop()
    }

    @objc public func start(windowProvider: @escaping () -> UIWindow?) {
        self.windowProvider = windowProvider

        guard observers.isEmpty else {
            setEnabled(true)
            return
        }

        let center = NotificationCenter.default
        observers = [
            center.addObserver(
                forName: UIApplication.willResignActiveNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.showOverlayIfNeeded()
            },
            center.addObserver(
                forName: UIApplication.didBecomeActiveNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.hideOverlay()
            }
        ]

        setEnabled(true)
    }

    @objc public func stop() {
        let center = NotificationCenter.default
        observers.forEach(center.removeObserver)
        observers.removeAll()
        windowProvider = nil
        hideOverlay()
    }

    @objc public func setEnabled(_ enabled: Bool) {
        isEnabled = enabled
        if !enabled {
            hideOverlay()
        }
    }

    private func showOverlayIfNeeded() {
        guard isEnabled, overlayView == nil, let window = currentWindow() else {
            return
        }

        let overlay = makeOverlayView(frame: window.bounds)
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        window.addSubview(overlay)
        overlayView = overlay
    }

    private func hideOverlay() {
        overlayView?.removeFromSuperview()
        overlayView = nil
    }

    private func currentWindow() -> UIWindow? {
        if let window = windowProvider?() {
            return window
        }

        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)
    }

    private func makeOverlayView(frame: CGRect) -> UIView {
        if let storyboardView = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()?.view {
            storyboardView.frame = frame
            storyboardView.backgroundColor = .systemBackground
            return storyboardView
        }

        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        blurView.frame = frame

        let shield = UILabel(frame: .zero)
        shield.translatesAutoresizingMaskIntoConstraints = false
        shield.text = "Protected"
        shield.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        shield.textColor = .secondaryLabel

        blurView.contentView.addSubview(shield)
        NSLayoutConstraint.activate([
            shield.centerXAnchor.constraint(equalTo: blurView.contentView.centerXAnchor),
            shield.centerYAnchor.constraint(equalTo: blurView.contentView.centerYAnchor)
        ])

        return blurView
    }
}

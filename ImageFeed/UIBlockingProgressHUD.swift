import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    static  func show() {
        guard let window else { return }
        window.isUserInteractionEnabled = false
        ProgressHUD.animate()
    }
    static func dismiss() {
        guard let window else { return }
        window.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}

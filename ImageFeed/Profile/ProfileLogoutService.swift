import Foundation
import WebKit
import UIKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private init() { }
    
    func logout() {
        cleanCookies()
        clearProfileData()
        navigateToLoginScreen()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func clearProfileData() {
        ProfileService.shared.clearData()
        
        ProfileImageService.shared.clearImage()
        
        ImagesListService.shared.clearImages()
    }
    
    private func navigateToLoginScreen() {
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            let splashViewController = SplashViewController()
            window.rootViewController = UINavigationController(rootViewController: splashViewController)
            
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
        }
    }
}

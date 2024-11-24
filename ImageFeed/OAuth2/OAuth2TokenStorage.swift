import UIKit

final class OAuth2TokenStorage {
    private let tokenKey = "OAuth2Token"
    private let userDefaults = UserDefaults.standard
    
    var token: String? {
        get {
            userDefaults.string(forKey: tokenKey)
        }
        set {
            userDefaults.set(newValue, forKey: tokenKey)
        }
    }
}

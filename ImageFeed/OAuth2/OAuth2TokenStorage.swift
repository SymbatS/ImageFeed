import UIKit
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private let tokenKey = "OAuth2Token"
    
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            if let newValue = newValue {
                let saveSuccessful = KeychainWrapper.standard.set(newValue, forKey: tokenKey)
                if !saveSuccessful {
                    print("Failed to save token to Keychain")
                } else {
                    print("Token successfully saved to Keychain")
                }
            } else {
                let removeSuccessful = KeychainWrapper.standard.removeObject(forKey: tokenKey)
                if !removeSuccessful {
                    print("Failed to remove token from Keychain")
                } else {
                    print("Token successfully removed from Keychain")
                }
            }
        }
    }
}

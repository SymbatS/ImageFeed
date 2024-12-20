import Foundation

final class ProfileImageServiceSpy: ProfileImageServiceProtocol {
    var avatarURL: String?
    
    func clearImage() {
    }
}

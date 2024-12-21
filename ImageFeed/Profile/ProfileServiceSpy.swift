import Foundation

final class ProfileServiceSpy: ProfileServiceProtocol {
    
    func fetchProfile(completion: @escaping (Result<Profile, any Error>) -> Void) {
    }
    
    func clearData() {
    }
    
}

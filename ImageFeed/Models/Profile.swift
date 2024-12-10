import UIKit

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
    
    init(from profileResult: ProfileResult) {
        self.username = profileResult.username
        self.name = "\(profileResult.name ?? "")"
        self.loginName = "@\(profileResult.username)"
        self.bio = profileResult.bio
    }
}

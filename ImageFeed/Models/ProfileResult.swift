import UIKit

struct ProfileResult: Decodable {
    let id: String
    let username: String
    let name: String?
    let bio: String?
    let location: String?
    let totalLikes: Int?
    let totalPhotos: Int?
    let profileImage: ProfileImage?
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case name
        case bio
        case location
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case profileImage = "profile_image"
    }
}

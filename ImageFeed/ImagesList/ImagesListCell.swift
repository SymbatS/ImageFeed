import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet private weak var cellImage: UIImageView!
    
    @IBOutlet private weak var likeButton: UIButton!
    
    @IBOutlet private weak var dateLabel: UILabel!
    
    func configure(image: UIImage?, date: String, isLiked: Bool) {
        cellImage.image = image
        dateLabel.text = date
        
        let likeImage = isLiked ? UIImage(named: "Active") : UIImage(named: "No Active")
        likeButton.setImage(likeImage, for: .normal)
    }
}


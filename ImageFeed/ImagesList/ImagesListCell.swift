import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    private var gradientLayer: CAGradientLayer?
    
    @IBOutlet private weak var gradientView: UIView!
    
    @IBOutlet private weak var cellImage: UIImageView!
    
    @IBOutlet private weak var likeButton: UIButton!
    
    @IBOutlet private weak var dateLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = gradientView.bounds
    }
    
    private func setupGradient() {
        guard gradientLayer == nil else { return }
        
        gradientLayer = CAGradientLayer()
        
        gradientLayer?.colors = [
            UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 0).cgColor,
            UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 0.2).cgColor
        ]
        
        gradientLayer?.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer?.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        gradientView.layer.addSublayer(gradientLayer!)
        gradientView.bringSubviewToFront(dateLabel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = nil
    }
    
    func configure(image: UIImage?, date: String, isLiked: Bool) {
        cellImage.image = image
        dateLabel.text = date
        
        let likeImage = isLiked ? UIImage(named: "Active") : UIImage(named: "No Active")
        likeButton.setImage(likeImage, for: .normal)
        
        setupGradient()
    }
}


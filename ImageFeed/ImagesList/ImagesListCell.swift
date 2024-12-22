import UIKit
import Kingfisher

// MARK: - ImagesListCell
final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet private weak var gradientView: UIView!
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var dateLabel: UILabel!
    
    private var gradientLayer: CAGradientLayer?
    var onLikeButtonTapped: (() -> Void)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = gradientView.bounds
        print("Button frame: \(likeButton.frame)")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = nil
        cellImage.kf.cancelDownloadTask()
    }
    
    private func setupGradient() {
        guard gradientLayer == nil else { return }
        
        gradientLayer = CAGradientLayer()
        gradientLayer?.colors = [
            UIColor.black.withAlphaComponent(0).cgColor,
            UIColor.black.withAlphaComponent(0.2).cgColor
        ]
        gradientLayer?.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer?.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientView.layer.insertSublayer(gradientLayer!, at: 0)
    }
    
    func configure(imageURL: URL?, date: String, isLiked: Bool, onLikeButtonTapped: @escaping () -> Void) {
        likeButton.setImage(
            UIImage(named: isLiked ? "Active" : "No Active"),
            for: .normal
        )
        likeButton.accessibilityIdentifier = isLiked ? "Active" : "No Active"
        dateLabel.text = date
        self.onLikeButtonTapped = onLikeButtonTapped
        cellImage.kf.setImage(with: imageURL) { result in
            switch result {
            case .success:
                break
            case .failure:
                print("Failed to load image")
            }
        }
        setupGradient()
    }
    
    @IBAction private func likeButtonTapped(_ sender: UIButton) {
        onLikeButtonTapped?()
    }
}


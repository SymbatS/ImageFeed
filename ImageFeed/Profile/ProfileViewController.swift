import Foundation
import UIKit

final class ProfileViewController: UIViewController {
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        label.font = .systemFont(ofSize: 23)
        label.text = "Екатерина Новикова"
        return label
    }()
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.textColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        label.font = .systemFont(ofSize: 13)
        label.text = "@ekaterina_nov"
        return label
    }()
    private lazy var descrLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        label.font = .systemFont(ofSize: 13)
        label.text = "Hello, world!"
        return label
    }()
    private lazy var avatarImageView: UIImageView = {
        let profileImage = UIImage(named: "UserPic")
        let imageView = UIImageView(image: profileImage)
        imageView.tintColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        return imageView
    }()
    private lazy var exitButton: UIButton = {
        let button = UIButton.systemButton(with: UIImage(systemName: "ipad.and.arrow.forward")!,
                                           target: self,
                                           action: #selector(self.didTapLogoutButton))
        button.tintColor = UIColor(red: 245/255, green: 107/255, blue: 108/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
    }
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            
            nicknameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nicknameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            descrLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            descrLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8),
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            exitButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor)
        ])
    }
    
    @objc
    private func didTapLogoutButton() {
        nameLabel.text = ""
        nicknameLabel.text = ""
        descrLabel.text = ""
        avatarImageView.image = UIImage(systemName: "person.crop.circle.fill")
        avatarImageView.tintColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
    }
}

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.textColor = .white
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
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.textColor = .white
        label.font = .systemFont(ofSize: 13)
        label.text = "Hello, world!"
        return label
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        return imageView
    }()
    
    private lazy var exitButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(self.didTapLogoutButton)
        )
        button.tintColor = UIColor(red: 245/255, green: 107/255, blue: 108/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "ypBlack")
        setupConstraints()
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self else { return }
            self.updateAvatar()
        }
        updateAvatar()
        fetchAndUpdateProfile()
    }
    
    private func updateAvatar() {
        guard let avatarURLString = ProfileImageService.shared.avatarURL,
              let avatarURL = URL(string: avatarURLString)
        else {
            avatarImageView.image = UIImage(systemName: "person.crop.circle.fill")
            avatarImageView.tintColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
            return
        }
        
        avatarImageView.kf.setImage(
            with: avatarURL,
            placeholder: UIImage(systemName: "person.crop.circle"),
            options: [
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ],
            completionHandler: { result in
                switch result {
                case .success:
                    print("Avatar loaded successfully.")
                case .failure(let error):
                    print("Error loading avatar: \(error)")
                }
            }
        )
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            
            nicknameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nicknameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8),
            
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            exitButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor)
        ])
    }
    
    @objc
    private func didTapLogoutButton() {
        showLogoutAlert()
    }
    
    private func performLogout() {
        nameLabel.text = ""
        nicknameLabel.text = ""
        descriptionLabel.text = ""
        avatarImageView.image = UIImage(systemName: "person.crop.circle.fill")
        avatarImageView.tintColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)

        let tokenStorage = OAuth2TokenStorage()
        tokenStorage.token = nil
    }
    
    private func fetchAndUpdateProfile() {
        profileService.fetchProfile { [weak self] result in
            switch result {
            case .success(let profile):
                self?.updateProfileDetails(profile: profile)
            case .failure(let error):
                print("Error fetching profile: \(error.localizedDescription)")
                self?.showErrorAlert()
            }
        }
    }
    
    private func updateProfileDetails(profile: Profile) {
        nameLabel.text = profile.name
        nicknameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Не удалось загрузить профиль.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
    private func showLogoutAlert() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            preferredStyle: .alert
        )
        let yesAction = UIAlertAction(title: "Да", style: .default) { _ in
            self.performLogout()
        }
        let noAction = UIAlertAction(
            title: "Нет",
            style: .cancel,
            handler: nil
        )
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
}

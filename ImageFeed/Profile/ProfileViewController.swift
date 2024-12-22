import UIKit
import Kingfisher

protocol ProfileViewProtocol: AnyObject {
    func displayProfile(name: String, nickname: String, bio: String)
    func displayAvatar(imageURL: URL?)
    func displayError(message: String)
    func clearProfile()
}

final class ProfileViewController: UIViewController, ProfileViewProtocol {
    var presenter: ProfileViewPresenterProtocol?
    
    private lazy var nameLabel = UILabel()
    private lazy var nicknameLabel = UILabel()
    private lazy var descriptionLabel = UILabel()
    private lazy var avatarImageView = UIImageView()
    private lazy var exitButton = UIButton()
    
    init(presenter: ProfileViewPresenterProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.view = self
        presenter?.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "ypBlack")
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.layer.cornerRadius = 35
        avatarImageView.clipsToBounds = true
        view.addSubview(avatarImageView)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .white
        nameLabel.font = .systemFont(ofSize: 23)
        view.addSubview(nameLabel)
        
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        nicknameLabel.textColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        nicknameLabel.font = .systemFont(ofSize: 13)
        view.addSubview(nicknameLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textColor = .white
        descriptionLabel.font = .systemFont(ofSize: 13)
        view.addSubview(descriptionLabel)
        
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.setImage(UIImage(systemName: "ipad.and.arrow.forward"), for: .normal)
        exitButton.tintColor = UIColor(red: 245/255, green: 107/255, blue: 108/255, alpha: 1)
        exitButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        exitButton.accessibilityIdentifier = "Logout"
        view.addSubview(exitButton)
        
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
    func didTapLogoutButton() {
        showLogoutAlert()
    }
    
    // MARK: - ProfileViewProtocol
    
    func displayProfile(name: String, nickname: String, bio: String) {
        nameLabel.text = name
        nicknameLabel.text = nickname
        descriptionLabel.text = bio
    }
    
    func displayAvatar(imageURL: URL?) {
        guard let imageURL = imageURL else {
            avatarImageView.image = UIImage(systemName: "person.crop.circle.fill")
            avatarImageView.tintColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
            return
        }
        
        avatarImageView.kf.setImage(
            with: imageURL,
            placeholder: UIImage(systemName: "person.crop.circle")
        )
    }
    
    func displayError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
    
    func clearProfile() {
        nameLabel.text = ""
        nicknameLabel.text = ""
        descriptionLabel.text = ""
        avatarImageView.image = UIImage(systemName: "person.crop.circle.fill")
        avatarImageView.tintColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
    }
    
    private func showLogoutAlert() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            preferredStyle: .alert
        )
        
        let actionYes = UIAlertAction(
            title: "Да",
            style: .default)
        { [weak self] _ in
            self?.presenter?.didTapLogout()
        }
        let actionNo = UIAlertAction(
            title: "Нет",
            style: .default)
        alert.addAction(actionYes)
        alert.addAction(actionNo)
        present(alert, animated: true)
    }
}


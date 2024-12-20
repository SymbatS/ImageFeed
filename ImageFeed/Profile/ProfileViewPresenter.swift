import Foundation

protocol ProfileViewPresenterProtocol {
    var view: ProfileViewProtocol? { get set }
    func viewDidLoad()
    func didTapLogout()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewProtocol?
    var viewDidLoadDidCalled = false
    var viewDidTapLogout = false
    private let profileService: ProfileServiceProtocol
    private let profileImageService: ProfileImageServiceProtocol
    
    init(profileService: ProfileServiceProtocol = ProfileService.shared,
         profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared) {
        self.profileService = profileService
        self.profileImageService = profileImageService
    }
    
    func viewDidLoad() {
        fetchProfile()
        updateAvatar()
        observeAvatarChanges()
        viewDidLoadDidCalled = true
    }
    
    func didTapLogout() {
        clearProfile()
        ProfileLogoutService.shared.logout()
        viewDidTapLogout = true
    }
    
    private func fetchProfile() {
        profileService.fetchProfile { [weak self] result in
            switch result {
            case .success(let profile):
                self?.view?.displayProfile(
                    name: profile.name,
                    nickname: profile.loginName,
                    bio: profile.bio ?? ""
                )
            case .failure:
                self?.view?.displayError(message: "Не удалось загрузить профиль.")
            }
        }
    }
    
    private func updateAvatar() {
        guard let avatarURLString = profileImageService.avatarURL,
              let avatarURL = URL(string: avatarURLString) else {
            view?.displayAvatar(imageURL: nil)
            return
        }
        view?.displayAvatar(imageURL: avatarURL)
    }
    
    private func observeAvatarChanges() {
        NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateAvatar()
        }
    }
    
    private func clearProfile() {
        view?.clearProfile()
        profileService.clearData()
        profileImageService.clearImage()
        OAuth2TokenStorage.shared.token = nil
    }
}

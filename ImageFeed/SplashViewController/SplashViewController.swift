import UIKit

final class SplashViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    private let mainStoryboardName = "Main"
    private let tabBarControllerIdentifier = "TabBarViewController"
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"

    private let storage = OAuth2TokenStorage()
    
    override func viewDidAppear (_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if storage.token != nil  {
            fetchProfile()
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let tabBarController = UIStoryboard(name: mainStoryboardName, bundle: .main)
            .instantiateViewController(withIdentifier: tabBarControllerIdentifier)
           
        window.rootViewController = tabBarController
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)")
                return
            }
            
            viewController.delegate = self
            
        } else {
            super.prepare(for: segue, sender: sender)
           }
    }
}

// MARK: - AuthViewControllerDelegate

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        fetchProfile()
    }
    private func fetchProfile() {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile {  [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            switch result {
            case .success(let profile):
                self.switchToTabBarController()
                print("Profile fetched \(profile)")
            case .failure(let error):
                print("Error fetching profile \(error)")
                break
            }
        }
    }
}

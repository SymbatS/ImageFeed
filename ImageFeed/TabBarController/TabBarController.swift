import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController {
            let presenterImagesList = ImageListViewPresenter(view: imagesListViewController)
            imagesListViewController.presenter = presenterImagesList
            let profileService = ProfileService.shared
            let presenter = ProfileViewPresenter(profileService: profileService)
            let profileViewController = ProfileViewController(presenter: presenter)
            profileViewController.tabBarItem = UITabBarItem(
                title: "",
                image: UIImage(named: "tab_profile_active"),
                selectedImage: nil
            )
            imagesListViewController.tabBarItem = UITabBarItem(
                title: "",
                image: UIImage(named: "tab_editorial_active"),
                selectedImage: nil)
            self.viewControllers = [imagesListViewController, profileViewController]
        }
    }
}

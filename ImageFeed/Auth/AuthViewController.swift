import UIKit
import ProgressHUD

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

final class AuthViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    weak var delegate: AuthViewControllerDelegate?
    private let backButton = UIButton(frame: .zero)
    private let showAuthViewSegueIdentifier = "ShowWebView"
    private let oauth2Service = OAuth2Service.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else {
                assertionFailure("Failed to prepare for \(showAuthViewSegueIdentifier)")
                return
            }
            let authHelper = AuthHelper()
            let webViewPresenter = WebViewPresenter(authHelper: authHelper)
            webViewViewController.presenter = webViewPresenter
            webViewPresenter.view = webViewViewController
            webViewViewController.delegate = self
            navigationController?.setNavigationBarHidden(false, animated: false)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - WebViewViewControllerDelegate

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        DispatchQueue.main.async {
            UIBlockingProgressHUD.show()
        }
        oauth2Service.fetchOAuthToken(code) { result in
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let token):
                print("Successfully received token: \(token)")
                self.delegate?.didAuthenticate(self)
            case .failure(let error):
                print("Failed to fetch token: \(error.localizedDescription)")
                self.showAlert()
            }
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "Ок", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}


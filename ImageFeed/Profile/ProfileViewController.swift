import Foundation
import UIKit

final class ProfileViewController: UIViewController {
    private var nameLabel: UILabel?
    private var nicknameLabel: UILabel?
    private var descrLabel: UILabel?
    private var imageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileImage = UIImage(named: "UserPic")
        let imageView = UIImageView(image: profileImage)
        imageView.tintColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        self.imageView = imageView
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        nameLabel.font = .systemFont(ofSize: 23)
        nameLabel.text = "Екатерина Новикова"
        self.nameLabel = nameLabel
        
        let nickNameLabel = UILabel()
        nickNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nickNameLabel)
        nickNameLabel.textColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        nickNameLabel.font = .systemFont(ofSize: 13)
        nickNameLabel.text = "@ekaterina_nov"
        self.nicknameLabel = nickNameLabel
        
        let descrLabel = UILabel()
        descrLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descrLabel)
        descrLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        descrLabel.font = .systemFont(ofSize: 13)
        descrLabel.text = "Hello, world!"
        self.descrLabel = descrLabel
        
        let button = UIButton.systemButton(with: UIImage(systemName: "ipad.and.arrow.forward")!,
                                           target: self,
                                           action: #selector(self.didTapLogoutButton))
        button.tintColor = UIColor(red: 245/255, green: 107/255, blue: 108/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            
            nickNameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            nickNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            descrLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            descrLabel.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor, constant: 8),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
            
        ])
    }
    
    @objc
    private func didTapLogoutButton() {
        
        nameLabel?.removeFromSuperview()
        nameLabel = nil
        nicknameLabel?.removeFromSuperview()
        nicknameLabel = nil
        descrLabel?.removeFromSuperview()
        descrLabel = nil
        imageView?.image = UIImage(systemName: "person.crop.circle.fill")
        imageView?.tintColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
    }
}



import UIKit

class HomeController: UIViewController {

    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize:24 , weight: .bold)
        label.text = "loading"
        label.numberOfLines = 2
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector (didTapLogout))
        self.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    
    
    @objc private func didTapLogout() {
        AuthService.shared.signOut{ [weak self] error in
            guard let self = self else { return }
            if let error = error {
                AlertManager.showLogOutErrorAlert(on: self,with: error)
                return
            }
            
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
        }
            
        }
    }

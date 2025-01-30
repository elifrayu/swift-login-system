//
//  SceneDelegate.swift
//  swift-login-system
//
//  Created by elif uyar on 2.11.2024.
//
import UIKit
import FirebaseAuth
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        // Kullanıcı oturum kontrolü
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        
        if isLoggedIn {
            // Kullanıcı giriş yaptıysa MainViewController
            let mainVC = MainViewController()
            let navigationController = UINavigationController(rootViewController: mainVC)
            window.rootViewController = navigationController
        } else {
            // Kullanıcı giriş yapmadıysa SignInViewController
            let signInVC = LoginController()
            let navigationController = UINavigationController(rootViewController: signInVC)
            window.rootViewController = navigationController
        }
        
        self.window = window
        window.makeKeyAndVisible()
    }
    public func checkAuthentication(){
        if Auth.auth().currentUser == nil{
            self.goToController(with: LoginController())
            
        }else{
            self.goToController(with: HomeController())
        }
        
    }
    private func goToController(with viewController: UIViewController){
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.25){
                self?.window?.layer.opacity = 0
            }completion: { [weak self] _ in
                let nav=UINavigationController(rootViewController:viewController )
                nav.modalPresentationStyle = .fullScreen
                self?.window?.rootViewController = nav
                
                UIView.animate(withDuration: 0.25){ [weak self] in
                    self?.window?.layer.opacity = 1
                }
            }
        }
        
    }
    
    
}

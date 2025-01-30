//
//  ProfilePhotoController.swift
//  swift-login-system
//
//  Created by elif uyar on 17.11.2024.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore
import PhotosUI


class ProfilePhotoController: UIViewController {
    
        private let profileImageView = UIImageView()
        private let usernameLabel = UILabel()
        private let emailLabel = UILabel()
        private let changeProfileImageButton = UIButton()
        private let logoutButton = UIButton()
        private let profiliSilButton = UIButton()
        private let deleteProfileImageButton = UIButton()
        
        private var user: User?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            setupUI()
            setupBackButton()
            checkIfUserIsLoggedIn()
        }
        
        private func setupUI() {
            self.view.backgroundColor = .white
            
            // Profil resmi için UIImageView
            profileImageView.translatesAutoresizingMaskIntoConstraints = false
            profileImageView.layer.cornerRadius = 50
            profileImageView.clipsToBounds = true
            self.view.addSubview(profileImageView)
            
            // Profil resmini değiştir butonu
            changeProfileImageButton.translatesAutoresizingMaskIntoConstraints = false
            changeProfileImageButton.setTitle("Profil Resmini Ekle", for: .normal)
            changeProfileImageButton.setTitleColor(.blue, for: .normal)
            changeProfileImageButton.addTarget(self, action: #selector(didTapChangeProfileImage), for: .touchUpInside)
            self.view.addSubview(changeProfileImageButton)
            
            // Profil fotoğrafını sil butonu
            deleteProfileImageButton.translatesAutoresizingMaskIntoConstraints = false
            deleteProfileImageButton.setTitle("Profil Fotoğrafını Sil", for: .normal)
            deleteProfileImageButton.setTitleColor(.red, for: .normal)
            deleteProfileImageButton.addTarget(self, action: #selector(deleteProfileImage), for: .touchUpInside)
            self.view.addSubview(deleteProfileImageButton)
            
            // Kullanıcı adı ve e-posta label'ları
            usernameLabel.translatesAutoresizingMaskIntoConstraints = false
            usernameLabel.font = UIFont.boldSystemFont(ofSize: 20)
            self.view.addSubview(usernameLabel)
            
            emailLabel.translatesAutoresizingMaskIntoConstraints = false
            emailLabel.font = UIFont.systemFont(ofSize: 16)
            self.view.addSubview(emailLabel)
            
            // Çıkış yap butonu
            logoutButton.translatesAutoresizingMaskIntoConstraints = false
            logoutButton.setTitle("Çıkış Yap", for: .normal)
            logoutButton.setTitleColor(.red, for: .normal)
            logoutButton.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
            self.view.addSubview(logoutButton)
            
            // Profili Sil butonu
            profiliSilButton.translatesAutoresizingMaskIntoConstraints = false
            profiliSilButton.setTitle("Profili Sil", for: .normal)
            profiliSilButton.setTitleColor(.red, for: .normal)
            profiliSilButton.addTarget(self, action: #selector(deleteProfile), for: .touchUpInside)
            self.view.addSubview(profiliSilButton)
            
            // AutoLayout
            NSLayoutConstraint.activate([
                profileImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                profileImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                profileImageView.widthAnchor.constraint(equalToConstant: 100),
                profileImageView.heightAnchor.constraint(equalToConstant: 100),
                
                changeProfileImageButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
                changeProfileImageButton.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
                
                deleteProfileImageButton.topAnchor.constraint(equalTo: changeProfileImageButton.bottomAnchor, constant: 10),
                deleteProfileImageButton.centerXAnchor.constraint(equalTo: changeProfileImageButton.centerXAnchor),
                
                usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 50),
                usernameLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100),
                
                emailLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
                emailLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10),
                
                logoutButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                logoutButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                
                profiliSilButton.bottomAnchor.constraint(equalTo: logoutButton.topAnchor, constant: -20),
                profiliSilButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            ])
        }
        
    private func setupBackButton() {
        // UIButton oluştur
        let backButton = UIButton(type: .system)
        backButton.setTitle("Geri", for: .normal)
        backButton.setTitleColor(.blue, for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false

        // Butona aksiyon ekle
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)

        // Görünüme ekle
        view.addSubview(backButton)

        // AutoLayout ile konumlandırma
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }

    @objc private func didTapBackButton() {
        // Modal ekranı kapat
        dismiss(animated: true, completion: nil)
    }
        private func checkIfUserIsLoggedIn() {
            if let user = Auth.auth().currentUser {
                self.fetchUserData(userId: user.uid)
            } else {
                print("Kullanıcı giriş yapmamış.")
            }
        }
   
        private func fetchUserData(userId: String) {
            let db = Firestore.firestore()
            let userRef = db.collection("users").document(userId)
            
            userRef.getDocument { [weak self] document, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Firestore'dan kullanıcı verisi çekme hatası: \(error.localizedDescription)")
                    return
                }
                
                guard let document = document, document.exists else {
                    print("Kullanıcı verisi bulunamadı.")
                    return
                }
                
                let data = document.data()
                let username = data?["username"] as? String ?? "Bilinmiyor"
                let email = data?["email"] as? String ?? "Bilinmiyor"
                let profileImageUrl = data?["profileImageURL"] as? String
                
                self.usernameLabel.text = username
                self.emailLabel.text = email
                
                if let profileImageUrl = profileImageUrl {
                    self.loadProfileImage(from: profileImageUrl)
                } else {
                    self.changeProfileImageButton.isHidden = false
                }
            }
        }
        
        private func loadProfileImage(from url: String) {
            guard let url = URL(string: url) else {
                print("Geçersiz URL")
                return
            }

            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Resim yükleme hatası: \(error.localizedDescription)")
                        return
                    }

                    if let data = data, let image = UIImage(data: data) {
                        self?.profileImageView.image = image
                        self?.changeProfileImageButton.isHidden = true
                    }
                }
            }
            task.resume()
        }
        
        @objc private func didTapChangeProfileImage() {
            var configuration = PHPickerConfiguration()
            configuration.filter = .images
            configuration.selectionLimit = 1
            
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            present(picker, animated: true)
        }
    
        @objc private func didTapLogout() {
                do {
                    try Auth.auth().signOut()
                    let signInController = LoginController()
                    signInController.modalPresentationStyle = .fullScreen
                    self.present(signInController, animated: true, completion: nil)
                } catch let signOutError as NSError {
                    print("Error signing out: %@", signOutError)
                }
            }
        
        @objc private func deleteProfile() {
            guard let user = Auth.auth().currentUser else { return }
            
            user.delete { [weak self] error in
                if let error = error {
                    print("Kullanıcı silme hatası: \(error.localizedDescription)")
                    return
                }
                
                let db = Firestore.firestore()
                db.collection("users").document(user.uid).delete { error in
                    if let error = error {
                        print("Firestore'dan veri silme hatası: \(error.localizedDescription)")
                    } else {
                        print("Firestore'daki kullanıcı verisi başarıyla silindi.")
                    }
                }
                
                let storageRef = Storage.storage().reference().child("profile_images/\(user.uid).jpg")
                storageRef.delete { error in
                    if let error = error {
                        print("Profil resmi silme hatası: \(error.localizedDescription)")
                    } else {
                        print("Profil resmi başarıyla Firebase Storage'dan silindi.")
                    }
                }
                
                let signInController = LoginController()
                signInController.modalPresentationStyle = .fullScreen
                self?.present(signInController, animated: true, completion: nil)
            }
        }
        
        @objc private func deleteProfileImage() {
            guard let user = Auth.auth().currentUser else { return }
            
            let storageRef = Storage.storage().reference().child("profile_images/\(user.uid).jpg")
            storageRef.delete { error in
                if let error = error {
                    print("Profil fotoğrafı silme hatası: \(error.localizedDescription)")
                } else {
                    print("Profil fotoğrafı başarıyla silindi.")
                    self.profileImageView.image = nil
                    self.changeProfileImageButton.isHidden = false
                }
            }
        }
    }

    extension ProfilePhotoController: PHPickerViewControllerDelegate {
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true, completion: nil)
            
            guard let firstResult = results.first else { return }
            
            if firstResult.itemProvider.canLoadObject(ofClass: UIImage.self) {
                firstResult.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                    if let error = error {
                        print("Resim yüklenirken hata: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let image = object as? UIImage else { return }
                    
                    DispatchQueue.main.async {
                        self?.profileImageView.image = image
                        self?.uploadProfileImage(image)
                    }
                }
            }
        }
        
        private func uploadProfileImage(_ image: UIImage) {
            guard let user = Auth.auth().currentUser else { return }
            
            let storageRef = Storage.storage().reference().child("profile_images/\(user.uid).jpg")
            if let imageData = image.jpegData(compressionQuality: 0.75) {
                storageRef.putData(imageData, metadata: nil) { [weak self] (metadata, error) in
                    if let error = error {
                        print("Resim yüklerken hata: \(error.localizedDescription)")
                        return
                    }
                    
                    storageRef.downloadURL { (url, error) in
                        if let error = error {
                            print("Resim URL'si alınırken hata: \(error.localizedDescription)")
                            return
                        }
                        
                        guard let downloadURL = url else { return }
                        
                        let db = Firestore.firestore()
                        let userRef = db.collection("users").document(user.uid)
                        userRef.updateData([
                            "profileImageURL": downloadURL.absoluteString
                        ]) { error in
                            if let error = error {
                                print("Firestore verisi güncellenirken hata: \(error.localizedDescription)")
                            } else {
                                print("Profil resmi başarıyla güncellendi.")
                            }
                        }
                    }
                }
            }
        }

}

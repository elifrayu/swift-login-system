//
//  DronesViewController.swift
//  swift-login-system
//
//  Created by elif uyar on 17.11.2024.
//
/*import UIKit
import FirebaseFirestore

class DronesViewController: UIViewController {
    private let tableView = UITableView()
    private var drones: [Drone] = []
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Dronlarım"
        
        setupTableView()
        fetchDronesFromFirestore()
        
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }


    /*@objc private func openProfilePhotoController() {
        print("Hesabım butonuna tıklandı!")
        let profilePhotoVC = ProfilePhotoController()
        navigationController?.pushViewController(profilePhotoVC, animated: true)
    }*/

    
    private func fetchDronesFromFirestore() {
        db.collection("drones").getDocuments { snapshot, error in
            if let error = error {
                print("Firestore hata: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            self.drones = documents.compactMap { doc -> Drone? in
                let data = doc.data()
                guard let imeiId = data["imeiId"] as? String,
                      let macId = data["macId"] as? String,
                      let ownerId = data["ownerId"] as? String,
                      let typeId = data["typeId"] as? String,
                      let imageURL = data["imageURL"] as? String? else { return nil }
                return Drone(imeiId: imeiId, macId: macId, ownerId: ownerId, typeId: typeId, imageURL: imageURL)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
   

}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension DronesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let drone = drones[indexPath.row]
        
        cell.textLabel?.text = "IMEI: \(drone.imeiId)"
        
        // Görseli göster
        if let imageURL = drone.imageURL {
            let imageView = UIImageView(frame: CGRect(x: 300, y: 10, width: 50, height: 50))
            loadImage(from: imageURL, into: imageView)
            cell.addSubview(imageView)
        }
        
        return cell
    }
    
    private func loadImage(from urlString: String, into imageView: UIImageView) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }.resume()
    }
}


// MARK: - Drone Model
struct Drone {
    let imeiId: String
    let macId: String
    let ownerId: String
    let typeId: String
    let imageURL: String?
}
*/
import UIKit
import FirebaseFirestore
import FirebaseAuth

class DronesViewController: UIViewController {
    private let tableView = UITableView()
    private var drones: [Drone] = []
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Dronlarım"
        setupBackButton()
        setupTableView()
        fetchDronesFromFirestore()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DroneTableViewCell.self, forCellReuseIdentifier: "DroneCell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -20),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }

    @objc private func didTapBackButton() {
        // Modal ekranı kapat
        dismiss(animated: true, completion: nil)
    }
        
        

    private func fetchDronesFromFirestore() {
            // Kullanıcının UID'sini alın
            guard let userId = Auth.auth().currentUser?.uid else {
                print("Kullanıcı oturum açmamış.")
                return
            }

            // Firestore'dan sadece oturum açmış kullanıcıya ait drone'ları çek
            db.collection("drones")
                .whereField("ownerId", isEqualTo: userId) // ownerId kullanıcı UID'sine eşit olanları al
                .getDocuments { [weak self] snapshot, error in
                    guard let self = self else { return }

                    if let error = error {
                        print("Firestore hata: \(error.localizedDescription)")
                        return
                    }

                    guard let documents = snapshot?.documents else {
                        print("Kullanıcıya ait drone bulunamadı.")
                        return
                    }

                    // Drone verilerini modele dönüştür
                    self.drones = documents.compactMap { doc -> Drone? in
                        let data = doc.data()
                        guard let imeiId = data["imeiId"] as? String,
                              let macId = data["macId"] as? String,
                              let ownerId = data["ownerId"] as? String,
                              let typeId = data["typeId"] as? String,
                              let name = data["name"] as? String,
                              let imageURL = data["imageURL"] as? String else {
                            print("Eksik veri: \(data)")
                            return nil
                        }
                        return Drone(imeiId: imeiId, macId: macId, ownerId: ownerId, typeId: typeId, name: name, imageURL: imageURL)
                    }

                    DispatchQueue.main.async {
                        print("Kullanıcıya ait \(self.drones.count) drone yüklendi.")
                        self.tableView.reloadData()
                    }
                }
        }
    }

// MARK: - UITableViewDelegate & UITableViewDataSource
extension DronesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DroneCell", for: indexPath) as? DroneTableViewCell else {
            return UITableViewCell()
        }
        
        let drone = drones[indexPath.row]
        cell.configure(with: drone)
        return cell
    }
}

// MARK: - Drone Model
struct Drone {
    let imeiId: String
    let macId: String
    let ownerId: String
    let typeId: String
    let name: String
    let imageURL: String
}

// MARK: - DroneTableViewCell
class DroneTableViewCell: UITableViewCell {
    private let droneImageView = UIImageView()
    private let nameLabel = UILabel()
    private let imeiLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Drone Resmi
        droneImageView.translatesAutoresizingMaskIntoConstraints = false
        droneImageView.contentMode = .scaleAspectFit
        droneImageView.clipsToBounds = true
        contentView.addSubview(droneImageView)
        
        // Adı
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        contentView.addSubview(nameLabel)
        
        // IMEI
        imeiLabel.translatesAutoresizingMaskIntoConstraints = false
        imeiLabel.font = UIFont.systemFont(ofSize: 14)
        imeiLabel.textColor = .gray
        contentView.addSubview(imeiLabel)
        
        // AutoLayout
        NSLayoutConstraint.activate([
            droneImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            droneImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            droneImageView.widthAnchor.constraint(equalToConstant: 50),
            droneImageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.leadingAnchor.constraint(equalTo: droneImageView.trailingAnchor, constant: 15),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            imeiLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            imeiLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            imeiLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with drone: Drone) {
        nameLabel.text = drone.name
        imeiLabel.text = "IMEI: \(drone.imeiId)"
        loadImage(from: drone.imageURL)
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                print("Resim yükleme hatası: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.droneImageView.image = image
            }
        }.resume()
    }
}


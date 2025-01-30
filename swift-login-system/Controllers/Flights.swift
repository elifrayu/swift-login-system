//
//  Flights.swift
//  swift-login-system
//
//  Created by elif uyar on 2.12.2024.
//

import Foundation
import UIKit
import FirebaseFirestore
import Firebase

class Flights: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // TableView
    private var tableView: UITableView!
    private var droneModels: [DroneModel] = [] // DroneModel olarak değiştirilmiş
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Flights"
        
        setupBackButton()
        // TableView oluştur ve ayarla
        setupTableView()
    
        fetchDrones()
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
    

    private func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DroneCell")

        // TableView'ı ekrana ekle
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50), // Üstten 50 piksel boşluk
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    
    // Firestore'dan verileri çek
    private func fetchDrones() {
        let db = Firestore.firestore()
        db.collection("droneTypes").getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching drones: \(error)")
                return
            }
            
            self.droneModels = snapshot?.documents.compactMap { document -> DroneModel? in
                let data = document.data()
                guard let name = data["name"] as? String,
                      let cost = data["costTR"] as? String,
                      let photoURL = data["photoURL"] as? String else { return nil }
                return DroneModel(name: name, cost: cost, photoURL: photoURL)
            } ?? []
            
            // TableView'ı yenile
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - TableView DataSource ve Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return droneModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DroneCell", for: indexPath)
        let drone = droneModels[indexPath.row]
        
        // Hücre görünümünü özelleştir
        cell.textLabel?.text = "\(drone.name) - Cost: \(drone.cost)₺"
        if let url = URL(string: drone.photoURL), let data = try? Data(contentsOf: url) {
            cell.imageView?.image = UIImage(data: data)
        } else {
            cell.imageView?.image = UIImage(systemName: "airplane")
        }
        return cell
    }
}

// DroneModel olarak yeniden adlandırıldı
struct DroneModel {
    let name: String
    let cost: String
    let photoURL: String
}

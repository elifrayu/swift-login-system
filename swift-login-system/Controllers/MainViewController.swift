

import UIKit

class CustomButtonWithIcon: UIButton {
    init(title: String, icon: UIImage?) {
        super.init(frame: .zero)

        var config = UIButton.Configuration.plain()
        config.image = icon
        config.title = title
        config.imagePlacement = .leading // İkonun metnin solunda olması
        config.imagePadding = 8 // İkon ile metin arasındaki boşluk
        self.configuration = config
        
        self.tintColor = .black
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomBottomButton: UIButton {
    init(title: String, icon: UIImage?) {
        super.init(frame: .zero)

        var config = UIButton.Configuration.plain()
        config.image = icon
        config.title = title
        config.imagePlacement = .leading // İkon metnin solunda
        config.imagePadding = 8 // İkon ile metin arasındaki boşluk
        self.configuration = config
        
        self.tintColor = .white
        self.backgroundColor = .clear
        self.layer.cornerRadius = 10 // Opsiyonel olarak köşe yuvarlama eklenebilir
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class MainViewController: UIViewController {

    // MARK: - UI Components
    private let searchField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Ara"
        textField.backgroundColor = .black
        textField.layer.cornerRadius = 8
        textField.leftViewMode = .always
        textField.leftView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        textField.leftView?.tintColor = .white
        textField.textColor = .white
        textField.layer.masksToBounds = true
        return textField
    }()
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let allDronesButton = CustomButtonWithIcon(title: "All Drones", icon: UIImage(systemName: "airplane"))
    private let dronesButton = CustomButtonWithIcon(title: "Drones", icon: UIImage(systemName: "camera.drone"))
    private let mapControlButton = CustomButtonWithIcon(title: "Map Control", icon: UIImage(systemName: "map"))
    private let serviceButton = CustomButtonWithIcon(title: "Flights", icon: UIImage(systemName: "airplane.takeoff"))
    private let profileButton = CustomBottomButton(title: "Profile", icon: UIImage(systemName: "person.circle"))
    
    
    private let connectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Bağlan", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let droneImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "droneImage") // Replace with actual image name
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        allDronesButton.addTarget(self, action: #selector(openDronesPage), for: .touchUpInside)
        profileButton.addTarget(self, action: #selector(openProfilePage), for: .touchUpInside)
        dronesButton.addTarget(self, action: #selector(openFlightsPage), for: .touchUpInside)
        connectButton.addTarget(self, action: #selector(connectAction), for: .touchUpInside)
        serviceButton.addTarget(self, action: #selector(openFlightsViewPage), for: .touchUpInside)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .black
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)

       
        contentView.addSubview(searchField)
        contentView.addSubview(allDronesButton)
        contentView.addSubview(dronesButton)
        contentView.addSubview(mapControlButton)
        contentView.addSubview(serviceButton)
        
        contentView.addSubview(connectButton)
        contentView.addSubview(droneImageView)
        contentView.addSubview(profileButton)
        
        // AutoLayout ayarları
        searchField.translatesAutoresizingMaskIntoConstraints = false
        allDronesButton.translatesAutoresizingMaskIntoConstraints = false
        dronesButton.translatesAutoresizingMaskIntoConstraints = false
        mapControlButton.translatesAutoresizingMaskIntoConstraints = false
        serviceButton.translatesAutoresizingMaskIntoConstraints = false
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        connectButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            
            contentView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.5),
            
            searchField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
                        searchField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                        searchField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                        searchField.heightAnchor.constraint(equalToConstant: 40),

            // Butonlar
            allDronesButton.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 20),
            allDronesButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            allDronesButton.widthAnchor.constraint(equalToConstant: 100),
            allDronesButton.heightAnchor.constraint(equalToConstant: 100),

            dronesButton.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 20),
            dronesButton.leadingAnchor.constraint(equalTo: allDronesButton.trailingAnchor, constant: 16),
            dronesButton.widthAnchor.constraint(equalToConstant: 100),
            dronesButton.heightAnchor.constraint(equalToConstant: 100),

            mapControlButton.topAnchor.constraint(equalTo: allDronesButton.bottomAnchor, constant: 20),
            mapControlButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mapControlButton.widthAnchor.constraint(equalToConstant: 100),
            mapControlButton.heightAnchor.constraint(equalToConstant: 100),
            
            serviceButton.topAnchor.constraint(equalTo: dronesButton.bottomAnchor, constant: 20),
            serviceButton.leadingAnchor.constraint(equalTo: mapControlButton.trailingAnchor, constant: 16),
            serviceButton.widthAnchor.constraint(equalToConstant: 100),
            serviceButton.heightAnchor.constraint(equalToConstant: 100),

            // Resim
            droneImageView.topAnchor.constraint(equalTo: serviceButton.bottomAnchor, constant: 20),
            droneImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            droneImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            droneImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),
            
            profileButton.topAnchor.constraint(equalTo: dronesButton.topAnchor), // Drones butonu ile aynı hizada
            profileButton.leadingAnchor.constraint(equalTo: dronesButton.trailingAnchor, constant: 16), // Drones butonunun sağında 16 birim mesafe
                profileButton.widthAnchor.constraint(equalToConstant: 100), // Sabit genişlik
                profileButton.heightAnchor.constraint(equalToConstant: 100)

        ])
        print(profileButton.isHidden) // Eğer true dönerse buton gizlenmiş demektir
        print(profileButton.alpha)
    }

    // MARK: - Actions
    @objc private func openProfilePage() {
        let profileVC = ProfilePhotoController()
        profileVC.modalPresentationStyle = .fullScreen
        self.present(profileVC, animated: true, completion: nil)
    }

    @objc private func openDronesPage() {
        let dronesVC = DronesViewController()
        dronesVC.modalPresentationStyle = .fullScreen
        self.present(dronesVC, animated: true, completion: nil)
    }
    @objc private func openFlightsPage() {
        let flightsVC = Flights()
        flightsVC.modalPresentationStyle = .fullScreen
        self.present(flightsVC, animated: true, completion: nil)
    }
    
    @objc private func openFlightsViewPage() {
        let dronesViewVC = FlightsViewController()
        dronesViewVC.modalPresentationStyle = .fullScreen
        self.present(dronesViewVC, animated: true, completion: nil)
    }

    @objc private func connectAction() {
        print("Bağlanılıyor...")
    }
    
}

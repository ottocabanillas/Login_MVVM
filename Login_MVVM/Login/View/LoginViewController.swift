//
//  LoginViewController.swift
//  Login_MVVM
//
//  Created by Oscar A. Rafael Cabanillas on 04/07/2024.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    private let loginViewModel = LoginViewModel(apiClient: APIClient())
    var cancellables = Set<AnyCancellable>()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Add Email"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Add Password"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Login"
        configuration.subtitle = "Subtitulo"
        configuration.image = UIImage(systemName: "play.circle.fill")
        configuration.imagePadding = 8
        
        let button = UIButton(type: .system, primaryAction: UIAction(handler: { [weak self] action in
            self?.startLogin()
        }))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = configuration
        return button
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.textColor = .red
        label.font = .systemFont(ofSize: 20, weight: .regular, width: .condensed)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        createBandingViewWithViewModel()
        
        [emailTextField,
         passwordTextField,
         loginButton,
         errorLabel].forEach(view.addSubview)
        
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 32),
            emailTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -20),
            
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 32),
            passwordTextField.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -20),
            
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20)
        ])
    }
    
    private func startLogin() {
        loginViewModel.userLogin(withEmail: emailTextField.text?.lowercased() ?? "", password: passwordTextField.text?.lowercased() ?? "")
    }
    
    func createBandingViewWithViewModel() {
        emailTextField.textPublisher
            .assign(to: \LoginViewModel.email, on: loginViewModel)
            .store(in: &cancellables)
        
        passwordTextField.textPublisher
            .assign(to: \LoginViewModel.password, on: loginViewModel)
            .store(in: &cancellables)
        
        loginViewModel.$isEnable
            .assign(to: \.isEnabled , on: loginButton)
            .store(in: &cancellables)
        
        loginViewModel.$showLoading
            .assign(to: \.configuration!.showsActivityIndicator , on: loginButton)
            .store(in: &cancellables)
        
        loginViewModel.$errorMessage
            .assign(to: \UILabel.text!, on: errorLabel)
            .store(in: &cancellables)
    }
}

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        return NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { notification in
                return (notification.object as? UITextField)?.text ?? ""
            }
            .eraseToAnyPublisher()
    }
}


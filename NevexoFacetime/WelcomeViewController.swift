//
//  ViewController.swift
//  NevexoFacetime
//
//  Created by Vlad Beraru on 26.04.2024.
//

import UIKit

// TODO: Auth Sign up / Sign in
// TODO: Join Call
// TODO: Sign out

class WelcomeViewController: UIViewController, WelcomeViewDelegate {
    
    override func loadView() {
        let view = WelcomeView()
        view.delegate = self
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Welcome"
    }
    
    private func showAccount() {
        let viewController = UINavigationController(rootViewController: AccountViewController())
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
    
    func didTapSignIn(email: String?, password: String?) {
        guard let email, let password else {
            let alert = UIAlertController(title: "Invalid Entry", message: "Please provide valid email/password", preferredStyle: .alert)
            alert.addAction(.init(title: "Dismiss", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        AuthManager.shared.signIn(email: email, password: password) { [weak self] done in
            guard done else { return }
            
            DispatchQueue.main.async {
                self?.showAccount()
            }
        }
    }
    
    func didTapSignUp(email: String?, password: String?) {
        guard let email, let password else {
            let alert = UIAlertController(title: "Invalid Entry", message: "Please provide valid email/password", preferredStyle: .alert)
            alert.addAction(.init(title: "Dismiss", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        AuthManager.shared.signUp(email: email, password: password) { [weak self] done in
            guard done else { return }
            
            DispatchQueue.main.async {
                self?.showAccount()
            }
        }
    }
}


//
//  AccountViewController.swift
//  NevexoFacetime
//
//  Created by Vlad Beraru on 26.04.2024.
//

import Combine
import StreamVideo
import StreamVideoUIKit
import StreamVideoSwiftUI
import UIKit

class AccountViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    
    private var activeCallView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Accout"
        view.backgroundColor = .systemGreen
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(signOut))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Join Call", style: .done, target: self, action: #selector(joinCall))
    }
    
    @objc private func signOut() {
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure?", preferredStyle: .alert)
        alert.addAction(.init(title: "Cancel", style: .cancel))
        alert.addAction(.init(title: "Sign out", style: .destructive, handler: { _ in
            AuthManager.shared.signOut()
            let viewController = UINavigationController(rootViewController: WelcomeViewController())
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
        }))
        present(alert, animated: true)
    }
    
    @objc private func joinCall() {
        guard let callViewModel = CallManager.shared.callViewModel else { return }
//        callViewModel.joinCall(callType: .default, callId: "default_2d693b94-04eb-4287-b921-db5c3283fb33")
//        callViewModel.startCall(callType: .default, callId: UUID().uuidString, members: [])
        
        showCallUI()
    }
    
    private func listenForIncpmingCalls() {
        guard let callViewModel = CallManager.shared.callViewModel else { return }
        
        callViewModel.$callingState.sink { [weak self] newState in
            switch newState {
            case .incoming(_):
                DispatchQueue.main.async {
                    self?.showCallUI()
                }
            case .idle:
                DispatchQueue.main.async {
                    self?.hideCallUI()
                }
            default:
                break
            }
        }
        .store(in: &cancellables)
    }
    
    private func showCallUI() {
        guard let callViewModel = CallManager.shared.callViewModel else { return }
        let callVC = CallViewController.make(with: callViewModel)
        view.addSubview(callVC.view)
        callVC.view.bounds = view.bounds
        activeCallView = callVC.view
    }
    
    private func hideCallUI() {
        activeCallView?.removeFromSuperview()
    }
}

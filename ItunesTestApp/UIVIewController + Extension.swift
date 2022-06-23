//
//  UIVIewController + Extension.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 31.01.2022.
//

import UIKit

extension UIViewController {
    func createCustomButton(selector: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "person.fill"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: selector, for: .touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: button)
        return menuBarItem
    }

    func showAlert(
        titleMessage: String,
        message: String,
        titleButton: String,
        completion: ((UIAlertAction) -> Void)? = nil
    ) {
        let dialogMessage = UIAlertController(
            title: titleMessage,
            message: message,
            preferredStyle: .alert
        )

        dialogMessage.addAction(
            UIAlertAction(
                title: titleButton,
                style: UIAlertAction.Style.default,
                handler: completion
            )
        )
        self.present(dialogMessage, animated: true, completion: nil)
    }
}
// MARK: - Keyboard show/hide notification

extension UIViewController {
    func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc func keyboardWillShow(notification: Notification) {}

    @objc func keyboardWillHide(notification: Notification) {}
}

extension UIViewController {
    func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }

    func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        self.lockOrientation(orientation)
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
}

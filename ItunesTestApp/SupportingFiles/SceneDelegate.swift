//
//  SceneDelegate.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 29.01.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
            _ scene: UIScene,
            willConnectTo session: UISceneSession,
            options connectionOptions: UIScene.ConnectionOptions
        ) {
            guard let windowScene = (scene as? UIWindowScene) else { return }
            window = UIWindow(windowScene: windowScene)
            let navigationController = UINavigationController()
            let moduleBuilder = ModuleBuilder()
            let router = Router(navigationController: navigationController, moduleBuilder: moduleBuilder)
            router.initialViewController()

            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
}




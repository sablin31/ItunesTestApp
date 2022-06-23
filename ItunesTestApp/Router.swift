//
//  Router.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 10.06.2022.
//

import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var moduleBuilder: BuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func routeToSignUpScreen()
    func routeToAlbumsScreen()
    func routeToDetailAlbumScreen(with album: Album)
    func routeToUserInfoScreen()
    func comeBackToPrevController() 
    func popToRoot()
}

class Router: RouterProtocol {
    // MARK: - Public properties

    var navigationController: UINavigationController?
    var moduleBuilder: BuilderProtocol?
    // MARK: - Init

    init(navigationController: UINavigationController, moduleBuilder: BuilderProtocol) {
        self.navigationController = navigationController
        self.moduleBuilder = moduleBuilder
    }
    // MARK: - Public methods

    func initialViewController() {
        if let navigationController = navigationController {
            guard let mainViewController = moduleBuilder?.createAuthorizationScreen(router: self) else { return }
            navigationController.viewControllers = [mainViewController]
        }
    }
    
    func routeToSignUpScreen() {
        if let navigationController = navigationController {
            guard let signUpViewController = moduleBuilder?.createSignUpScreen(
                router: self
            ) else { return }
            navigationController.pushViewController(signUpViewController, animated: true)
        }
    }
    
    func routeToAlbumsScreen() {
        if let navigationController = navigationController {
            guard let albumsViewController = moduleBuilder?.createAlbumsScreen(
                router: self
            ) else { return }
            navigationController.pushViewController(albumsViewController, animated: true)
        }
    }
    
    func routeToDetailAlbumScreen(with album: Album){
        if let navigationController = navigationController {
            guard let detailAlbumViewController = moduleBuilder?.createDetailAlbumScreen(
                with: album,
                router: self
            ) else { return }
            navigationController.pushViewController(detailAlbumViewController, animated: true)
        }
    }
    
    func routeToUserInfoScreen() {
        if let navigationController = navigationController {
            guard let userInfoViewController = moduleBuilder?.createUserInfoScreen(
                router: self
            ) else { return }
            navigationController.pushViewController(userInfoViewController, animated: true)
        }
    }
    
    func comeBackToPrevController() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }
    }
    
    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}

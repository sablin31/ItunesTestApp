//
//  ModuleBuilder.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 10.06.2022.
//

import UIKit

// MARK: - Builder protocol

protocol BuilderProtocol {
    func createAuthorizationScreen(router: RouterProtocol) -> UIViewController
    func createSignUpScreen(router: RouterProtocol) -> UIViewController
    func createAlbumsScreen(router: RouterProtocol) -> UIViewController
    func createDetailAlbumScreen(with album: Album, router: RouterProtocol) -> UIViewController
    func createUserInfoScreen(router: RouterProtocol) -> UIViewController
}
// MARK: - Module builder

class ModuleBuilder: BuilderProtocol {
    // MARK: - Public methods

    func createAuthorizationScreen(router: RouterProtocol) -> UIViewController {
        let view = AuthorizationViewController()
        let presenter = AuthorizationPresenter()
        let interactor = AuthorizationInteractor()
        view.router = router
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = view
        return view
    }
    
    func createSignUpScreen(router: RouterProtocol) -> UIViewController {
        let view = SignUpViewController()
        let presenter = SignUpPresenter()
        let interactor = SignUpInteractor()
        view.router = router
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = view
        return view
    }
    
    func createAlbumsScreen(router: RouterProtocol) -> UIViewController {
        let view = AlbumsViewController()
        let presenter = AlbumsPresenter()
        let interactor = AlbumsInteractor()
        view.router = router
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = view
        return view
    }
    
    func createDetailAlbumScreen(with album: Album, router: RouterProtocol) -> UIViewController {
        let view = DetailAlbumViewController()
        let presenter = DetailAlbumPresenter()
        let interactor = DetailAlbumInteractor()
        view.router = router
        view.interactor = interactor
        interactor.album = album
        interactor.presenter = presenter
        presenter.viewController = view
        return view
    }

    func createUserInfoScreen(router: RouterProtocol) -> UIViewController {
        let view = UserInfoViewController()
        let presenter = UserInfoPresenter()
        let interactor = UserInfoInteractor()
        view.router = router
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = view
        return view
    }
}

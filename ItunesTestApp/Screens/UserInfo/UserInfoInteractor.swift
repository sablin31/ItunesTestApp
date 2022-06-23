//
//  UserInfoInteractor.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 23.06.2022.
//

import Foundation

protocol UserInfoBusinessLogic: AnyObject {
    var presenter: UserInfoPresentationLogic? { get set }

    func fetchUserData(request: UserInfoModels.ShowPersonalDataUser.Request)
}

class UserInfoInteractor: UserInfoBusinessLogic {
    // MARK: - Public properties

    var presenter: UserInfoPresentationLogic?

    func fetchUserData(request: UserInfoModels.ShowPersonalDataUser.Request) {
        let activeUser = WorkerStorage.shared.activeUser

        let responce = UserInfoModels.ShowPersonalDataUser.Response(activeUser: activeUser)
        presenter?.presentUserData(response: responce)
    }
}

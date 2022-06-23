//
//  AuthorizationInteractor.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 12.06.2022.
//

import Foundation

protocol AuthorizationBusinessLogic: AnyObject {
    var presenter: AuthorizationPresentationLogic? { get set }
    var workerStorage: WorkerStorage { get set }

    func checkCurrentUser(request: AuthorizationModels.CheckUser.Request)
}

final class AuthorizationInteractor: AuthorizationBusinessLogic {
    var presenter: AuthorizationPresentationLogic?
    var workerStorage = WorkerStorage()

    func checkCurrentUser(request: AuthorizationModels.CheckUser.Request) {
        var description: DescriptionAuthorization
        var resultOperation = false

        if request.login.isEmpty || request.password.isEmpty {
            description = .fieldsIsEmpty
        } else {
            let user = findUserOnDataUsers(mail: request.login)
            if user == nil {
                description = .notFoundUser
            } else if user?.password != request.password {
                description = .wrongPass
            } else {
                if let activeUser = user {
                    WorkerStorage.shared.saveActiveUser(user: activeUser)
                    resultOperation = true
                    description = .success
                } else {
                    description = .undefinedError
                }
            }
        }

        let response = AuthorizationModels.CheckUser.Response(
            resultAuthorization: resultOperation,
            descriptionOperation: description
        )
        self.presenter?.presentResultAuthorization(response: response)
    }
}
// MARK: - Private methods

private extension AuthorizationInteractor {
    func findUserOnDataUsers(mail: String?) -> User? {
        let workerStorage = WorkerStorage.shared.users
        for user in workerStorage {
            if user.email == mail {
                return user
            }
        }
        return nil
    }
}

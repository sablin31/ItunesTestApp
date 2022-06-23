//
//  AuthorizationPresenter.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 10.06.2022.
//

import Foundation

protocol AuthorizationPresentationLogic: AnyObject {
    var viewController: AuthorizationDisplayLogic? { get set }

    func presentResultAuthorization(response: AuthorizationModels.CheckUser.Response)
}

final class AuthorizationPresenter: AuthorizationPresentationLogic {
    // MARK: - Public proterties

    weak var viewController: AuthorizationDisplayLogic?
    // MARK: - Public methods

    func presentResultAuthorization(response: AuthorizationModels.CheckUser.Response) {
        let result = response.resultAuthorization
        let description: String

        switch response.descriptionOperation {
        case .wrongPass: description = Constants.wrongPass
        case .notFoundUser: description = Constants.notFoundUser
        case .fieldsIsEmpty: description = Constants.fieldsIsEmpty
        case .success: description = Constants.success
        default: description = Constants.undefinedError
        }

        let viewModel = AuthorizationModels.CheckUser.ViewModel(
            resultAuthorization: result,
            descriptionOperation: description
        )
        viewController?.showResultAuthorization(viewModel: viewModel)
    }
}
// MARK: - Constants

extension AuthorizationPresenter {
    private enum Constants {
        static let success = "Success"
        static let fieldsIsEmpty = "E-mail and Password can not be empty"
        static let notFoundUser = "Not found user in this E-mail"
        static let wrongPass = "Wrong password!"
        static let undefinedError = "Undefined error"
    }
}

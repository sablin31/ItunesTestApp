//
//  UserInfoPresenter.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 23.06.2022.
//

import Foundation

protocol UserInfoPresentationLogic: AnyObject {
    var viewController: UserInfoDisplayLogic? { get set }

    func presentUserData(response: UserInfoModels.ShowPersonalDataUser.Response)
}

final class UserInfoPresenter: UserInfoPresentationLogic {
    // MARK: - Public proterties

    var viewController: UserInfoDisplayLogic?
    
    // MARK: - Private properties

    private var firstName = ""
    private var lastName = ""
    private var ageString = ""
    private var phone = ""
    private var email = ""
    private var password = ""
    
    // MARK: - Public methods

    func presentUserData(response: UserInfoModels.ShowPersonalDataUser.Response) {
        if let activeUser = response.activeUser {
            firstName = activeUser.firstName
            lastName = activeUser.lastName
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constants.dateFormat
            ageString = dateFormatter.string(from: activeUser.age)
            phone = activeUser.phone
            email = activeUser.email
            password = activeUser.password
        }

        let viewModel = UserInfoModels.ShowPersonalDataUser.ViewModel(
            firstName: firstName,
            lastName: lastName,
            ageString: ageString,
            phone: phone,
            email: email,
            password: password
        )
        viewController?.showPersonalData(viewModel: viewModel)
    }
}
extension UserInfoPresenter {
    private enum Constants {
        static let dateFormat = "dd.MM.yyyy"
    }
}

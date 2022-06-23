//
//  String + Extension.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 07.02.2022.
//

import Foundation

extension String {
    enum ValidTypes {
        case name
        case email
        case password
    }

    enum Regex: String {
        case name = "[a-zA-Z]{1,}"
        case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        case password = "(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{6,}"
    }

    func isValid(validType: ValidTypes) -> Bool {
        let format = "SELF MATCHES %@"
        var regex = ""

        switch validType {
        case .name: regex = Regex.name.rawValue
        case .email: regex = Regex.email.rawValue
        case .password: regex = Regex.password.rawValue
        }

        return NSPredicate(format: format, regex).evaluate(with: self)
    }

    func applyPatternOnNumbers(pattern: String, replacementCharacter: Character) -> String {
    var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacementCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
    
    func setDateFormat(backendDateFormat: String, to dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = backendDateFormat
        guard let backendDate = dateFormatter.date(from: self) else {return ""}
        
        let formatDate = DateFormatter()
        formatDate.dateFormat = dateFormat
        let date = formatDate.string(from: backendDate)
        return date
    }
}

//
//  Alert.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/1.
//  Copyright © 2018年 Annie. All rights reserved.
//

import Foundation
import SCLAlertView

enum Check: String {

    case yes = "Yes"

    case no = "No"

    func setButtonTitle() -> String {
        switch self {
        case .yes:
            return "確定"
        case .no:
            return "取消"
        }
    }
}

struct AlertManager {

    static func showEdit(title: String, subTitle: String) {

        let alert = SCLAlertView()

        alert.showEdit(title, subTitle: subTitle)
    }
}

struct AlertToUser1 {
    var alert = SCLAlertView()

}

class Alertmanager1 {

    static let shared = Alertmanager1()

    func showCheck(with title: String, message: String, delete: @escaping () -> Void, cancel: @escaping () -> Void) {

        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false)

        let alertView = SCLAlertView(appearance: appearance)

        alertView.addButton(Check.yes.setButtonTitle()) {
            delete()
        }
        alertView.addButton(Check.no.setButtonTitle()) {
            cancel()
        }

        alertView.showSuccess("", subTitle: NSLocalizedString(title, comment: message))
    }

}

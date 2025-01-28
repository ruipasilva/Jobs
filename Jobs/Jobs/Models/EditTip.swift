//
//  EditTip.swift
//  Jobs
//
//  Created by Rui Silva on 04/04/2024.
//

import Foundation
import TipKit

public struct EditTip: Tip {
    public var title: Text {
        Text("Wrong information or logo?")
    }

    public var message: Text? {
        Text(
            """
            To choose a different logo or edit the company information, tap the edit button.
            """
        )
    }
}

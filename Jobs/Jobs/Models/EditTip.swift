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
        Text("Wrong info or logo?")
    }
    
    public var message: Text? {
        Text("""
            Tap the logo to edit. Tap x to dismiss.
            """
        )
    }
}

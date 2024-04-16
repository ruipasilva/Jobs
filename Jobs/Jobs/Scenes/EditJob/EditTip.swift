//
//  EditTip.swift
//  Jobs
//
//  Created by Rui Silva on 04/04/2024.
//

import Foundation
import TipKit

struct EditTip: Tip {
    var title: Text {
        Text("Wrong info or logo?")
    }
    
    var message: Text? {
        Text("Tap here to edit.")
    }
}

//
//  AbilityLink.swift
//  Wannado
//
//  Created by admin on 2023/8/16.
//

import Foundation
import SwiftUI

struct AbilityLink:Identifiable {
    var id: String = UUID().uuidString
    let name:String
    let view:AnyView
}

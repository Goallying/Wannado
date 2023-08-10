//
//  WannadoApp.swift
//  Wannado
//
//  Created by admin on 2023/8/7.
//

import SwiftUI

@main
struct WannadoApp: App {
    
    
    @AppStorage("LOGIN_STATE") var loginState :Bool = false
    
    var body: some Scene {
        WindowGroup {
            if(loginState) {
                HomeView()
            }else{
                LoginView()
            }
            
        }
    }
}

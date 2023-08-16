//
//  LoginView.swift
//  Wannado
//
//  Created by admin on 2023/8/10.
//

import SwiftUI

struct LoginView: View {
    
    enum LoginTextfield:Hashable{
        case account
        case password
    }
    
    @AppStorage("LOGIN_STATE") var loginState :Bool = false
    @AppStorage("USER_NAME") var uname:String = ""
    @AppStorage("PASSWORD") var psw:String = ""
    
    @State private var account:String = ""
    @State private var password:String = ""
    @FocusState private var fieldInFocus:LoginTextfield?
    
    
    var body: some View {
        
        VStack(spacing:20){
            Text("账号登录")
                .foregroundColor(Color.black)
                .font(.title)
                .padding(.bottom ,20)
            HStack{
                Text("账号")
                    .font(.title3)
                TextField("请输入账号...", text: $account)
                    .focused($fieldInFocus, equals: .account)
                    .frame(height: 44)
                    .padding(.leading,10)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)
            }
            
            HStack{
                Text("密码")
                    .font(.title3)
                SecureField("请输入密码...", text: $password)
                    .focused($fieldInFocus, equals: .password)
                    .frame(height: 44)
                    .padding(.leading,10)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)
            }.padding(.bottom)
            
            Button {
                loginClick()
            } label: {
                Text("登录")
                    .frame(width: 164,height: 44)
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(10)
                
            }
            Spacer()

        }
        .padding(.horizontal,24)
        .offset(y:108)
    }
}


extension LoginView {
    
    func loginClick(){
        
        if(account.count > 0 && password.count > 0){
            loginState = true
            uname = account
            psw = password
            return
        }
        if(account.isEmpty){
            fieldInFocus = .account
        }
        else if (password.isEmpty){
            fieldInFocus = .password
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

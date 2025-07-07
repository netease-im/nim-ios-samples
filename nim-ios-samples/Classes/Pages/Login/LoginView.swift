//
//  LoginView.swift
//  nim-ios-samples
//
//  Created by 陈吉力 on 2024/11/25.
//

import SwiftUI

struct LoginView: View {
    var onSwitchView: () -> Void
    
    @State var accountId: String = ""
    @State var password: String = ""
    @State var loginResult: String = ""
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Text("登录")
                    .font(.title)
                    .padding()

                HStack {
                    Text("账号")
                        .padding()
                    TextField("请输入账号", text: $accountId)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 1000)
                        .textContentType(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .padding()
                }

                HStack {
                    Text("密码")
                        .padding()
                    SecureField("请输入密码", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .frame(maxWidth: 1000)
                        .padding()
                }

                Button(action: {
                    self.loginNIM()
                }) {
                    Text("登录")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
                Text(self.loginResult)
                    .padding()
                    .foregroundColor(.gray)
                Spacer()
            }
            Spacer()
        }
    }
    
    private func loginNIM()
    {
        // 校验参数
        if self.accountId.isEmpty {
            self.loginResult = "请输入账号"
            return
        }
        if self.password.isEmpty {
            self.loginResult = "请输入密码"
            return
        }
        
        // 规范参数
        let accountId = self.accountId
        let token = self.password.ntes_md5()
        let option = self.generateLoginOption()
        
        // 调用登录API
        NIMSDK.shared().v2LoginService.login(accountId, token: token, option: option) {
            self.loginResult = "登录成功"
            self.onSwitchView()
        } failure: { error in
            self.loginResult = "登录失败。\(error)"
        }

    }
    
    private func generateLoginOption() -> V2NIMLoginOption
    {
        let result = V2NIMLoginOption()
        result.retryCount = 3
        result.timeout = 3000
        result.forceMode = true
        return result
    }
}


#Preview {
    LoginView(onSwitchView: {})
}


//
//  nim_ios_samplesApp.swift
//  nim-ios-samples
//
//  Created by 陈吉力 on 2024/11/11.
//

import SwiftUI

@main
struct nim_ios_samplesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    init() {
        self.initNim()
    }
    
    func initNim()
    {
        Logger.log("NIM: to init SDK")
        let option = self.readNIMSDKOption()
        let v2Option = self.readV2NIMSDKOption()
        NIMSDK.shared().register(withOptionV2: option, v2Option: v2Option)
    }
    
    func readNIMSDKOption() -> NIMSDKOption
    {
        let option = NIMSDKOption.init(appKey: NIMConstant.DEFAULT_APP_KEY)
        return option
    }
    
    func readV2NIMSDKOption() -> V2NIMSDKOption
    {
        let option = V2NIMSDKOption.init()
        return option
    }
}

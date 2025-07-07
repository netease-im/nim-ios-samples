//
//  ContentView.swift
//  nim-ios-samples
//
//  Created by 陈吉力 on 2024/11/11.
//

import SwiftUI

struct ContentView: View {
    @State var isLoggedIn = false
    @State var viewType: ViewType = .login
    @State var selectedFunctionItem: FunctionViewListItem? = nil
  	var viewModel = FunctionViewListViewModel()
    var body: some View {
        ZStack {
            switch viewType {
            case .login:
                LoginView {
                    self.viewType = .function
                }
            case .function:
                FunctionView(viewModel: viewModel) { viewType, item in
                  self.selectedFunctionItem = item
                  self.viewType = viewType
                }
            case .execution:
                ExecutionView(item: self.selectedFunctionItem) {
                    self.viewType = .function
                }
            }
        }
    }
}


#Preview {
    ContentView()
}

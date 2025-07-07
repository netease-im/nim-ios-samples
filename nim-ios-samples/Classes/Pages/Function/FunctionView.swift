//
//  FunctionPage.swift
//  nim-ios-samples
//
//  Created by 陈吉力 on 2024/11/24.
//

// Views/FunctionView.swift
import SwiftUI

struct FunctionView: View {
    @StateObject var viewModel: FunctionViewListViewModel
    var onSwitchView: (ViewType, FunctionViewListItem?) -> Void
    
    var body: some View {
        TabView(selection: Binding(
            get: { viewModel.selectedTab },
            set: { viewModel.updateSelectedTab($0) }
        )) {
            ForEach(FunctionViewTabType.allCases, id: \.self) { FunctionViewTabType in
                if FunctionViewTabType != .unknown {
                    FunctionViewListTabView(
                        items: viewModel.filterItems(for: FunctionViewTabType),
                        onSwitchView: self.onSwitchView,
                        viewModel: self.viewModel
                    )
                    .tabItem {
                        Image(systemName: FunctionViewTabType.icon)
                        Text(FunctionViewTabType.title)
                    }
                    .tag(FunctionViewTabType)
                }
            }
        }
    }
}

struct FunctionViewListTabView: View {
    let items: [FunctionViewListItem]
    let onSwitchView: (ViewType, FunctionViewListItem?) -> Void
    @ObservedObject var viewModel: FunctionViewListViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.groupItems(items).keys.sorted(), id: \.self) { key in
                Section(header: Text(key)) {
                    ForEach(viewModel.groupItems(items)[key] ?? [], id: \.self) { item in
                        FunctionViewListItemRow(item: item).onTapGesture {
                            self.onSwitchView(ViewType.execution, item)
                        }
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
    }
}

struct FunctionViewListItemRow: View {
    let item: FunctionViewListItem
    
    var body: some View {
        HStack {
            Text(item.itemContent)
            Spacer()
            Text(item.itemType.description)
                .foregroundColor(.gray)
                .font(.caption)
        }
    }
}

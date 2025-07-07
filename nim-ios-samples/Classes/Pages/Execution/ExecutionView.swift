//
//  ExecutionView.swift
//  nim-ios-samples
//
//  Created by 陈吉力 on 2024/12/4.
//

import SwiftUI

struct ExecutionView: View {
    let item: FunctionViewListItem
    var onSwitchView: () -> Void
    
    // 模拟API定义 - 实际使用时应该从外部传入或动态生成
    @State private var apiDefinition: APIDefinition
    @StateObject private var parameterValues = ParameterValues()
    @State private var isExecuting = false
    @State private var executionResult: String = ""
    
    init(item: FunctionViewListItem?, onSwitchView: @escaping () -> Void) {
        if let item = item {
            self.item = item
        } else {
            self.item = FunctionViewListItem(.unknown, itemType: -1,itemContent:  "")
        }
        
        self.onSwitchView = onSwitchView
        if let apiDefinition = ExecutionViewModels.getAPIDefinition(item: self.item) {
            self.apiDefinition = apiDefinition
        } else {
            self.apiDefinition = APIDefinition(name: "未知API", parameters: [], executeFunction: { (params, callback) in
            })
        }
        
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // 顶部导航
                HStack {
                    Button {
                        onSwitchView()
                    } label: {
                        Text("Back")
                            .font(.system(size: 21))
                    }
                    .padding()
                    Spacer()
                }
                
                // API标题
                Text(apiDefinition.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                // 参数输入区域
                VStack(spacing: 12) {
                    ForEach(apiDefinition.parameters, id: \.name) { parameter in
                        ParameterInputView(
                            parameter: parameter,
                            parameterValues: parameterValues,
                            keyPath: parameter.name
                        )
                    }
                }
                .padding(.horizontal)
                
                // 执行按钮
                Button {
                    executeAPI()
                } label: {
                    HStack {
                        if isExecuting {
                            ProgressView()
                                .scaleEffect(0.8)
                        }
                        Text(isExecuting ? "执行中..." : "执行API")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isExecuting ? Color.gray : Color.blue)
                    .cornerRadius(10)
                }
                .disabled(isExecuting || !isFormValid())
                .padding(.horizontal)
                
                // 执行结果
                if !executionResult.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("执行结果:")
                            .font(.headline)
                        Text(executionResult)
                            .font(.system(.body, design: .monospaced))
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
        }
    }
    
    private func executeAPI() {
        isExecuting = true
        executionResult = ""
        apiDefinition.executeFunction(parameterValues.values) { result in
            executionResult = "API执行完成\n参数: \(formatParameters(parameterValues.values))\n结果：\(result)"
            isExecuting = false
        }
    }
    
    private func isFormValid() -> Bool {
        return validateParameters(apiDefinition.parameters, keyPath: "")
    }
    
    private func validateParameters(_ parameters: [APIParameter], keyPath: String) -> Bool {
        for parameter in parameters {
            let fullKey = keyPath.isEmpty ? parameter.name : "\(keyPath).\(parameter.name)"
            
            if !parameter.isOptional {
                let value = parameterValues.values[fullKey]
                if value == nil {
                    return false
                }
                
                // 验证字符串不为空
                if case .string = parameter.type, let stringValue = value as? String, stringValue.isEmpty {
                    return false
                }
            }
            
            // 递归验证自定义类型字段
            if let customFields = parameter.customTypeFields {
                if !validateParameters(customFields, keyPath: fullKey) {
                    return false
                }
            }
        }
        return true
    }
    
    private func formatParameters(_ params: [String: Any]) -> String {
        return params.map { "\($0.key): \($0.value)" }.joined(separator: "\n")
    }
}

// 参数输入组件
struct ParameterInputView: View {
    let parameter: APIParameter
    @ObservedObject var parameterValues: ParameterValues
    let keyPath: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 参数标题
            HStack {
                Text(parameter.name)
                    .font(.headline)
                if !parameter.isOptional {
                    Text("*")
                        .foregroundColor(.red)
                }
                Spacer()
            }
            
            // 参数描述
            if let description = parameter.description {
                Text(description)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            // 根据参数类型生成输入控件
            switch parameter.type {
            case .string:
                if let defaultValue = parameter.defaultValue as? String {
                    StringInputView(keyPath: keyPath, parameterValues: parameterValues, defaultValue: defaultValue)
                } else {
                    StringInputView(keyPath: keyPath, parameterValues: parameterValues)
                }
            case .int:
                if let defaultValue = parameter.defaultValue as? Int {
                    IntInputView(keyPath: keyPath, parameterValues: parameterValues, defaultValue: defaultValue)
                } else {
                    IntInputView(keyPath: keyPath, parameterValues: parameterValues)
                }
            case .double:
                if let defaultValue = parameter.defaultValue as? Double {
                    DoubleInputView(keyPath: keyPath, parameterValues: parameterValues, defaultValue: defaultValue)
                } else {
                    DoubleInputView(keyPath: keyPath, parameterValues: parameterValues)
                }
            case .bool:
                if let defaultValue = parameter.defaultValue as? Bool {
                    BoolInputView(keyPath: keyPath, parameterValues: parameterValues, defaultValue: defaultValue)
                } else {
                    BoolInputView(keyPath: keyPath, parameterValues: parameterValues)
                }
            case .custom:
                CustomTypeInputView(
                    parameter: parameter,
                    parameterValues: parameterValues,
                    keyPath: keyPath
                )
            case .button:
                ButtonView(keyPath: keyPath, parameterValues: parameterValues) {
                    self.parameter.onClick?()
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(8)
    }
}

struct ButtonView: View {
    let keyPath: String
    @ObservedObject var parameterValues: ParameterValues
    var defaultValue: String?
    var onClick: (() -> Void)?
    @State private var text: String = ""
    
    init(keyPath: String, parameterValues: ParameterValues, defaultValue: String? = nil, onClick: (() -> Void)? = nil) {
        self.keyPath = keyPath
        self.onClick = onClick
        self.parameterValues = parameterValues
        self.defaultValue = defaultValue
        if let defaultValue = defaultValue {
            _text = State(initialValue: defaultValue)
        }
        self.onClick = onClick
    }
    
    var body: some View {
        Button {
            self.onClick?()
        } label: {
            HStack {
                Text(self.text)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}

// 字符串输入
struct StringInputView: View {
    let keyPath: String
    @ObservedObject var parameterValues: ParameterValues
    var defaultValue: String?
    @State private var text: String = ""
    
    init(keyPath: String, parameterValues: ParameterValues, defaultValue: String? = nil) {
        self.keyPath = keyPath
        self.parameterValues = parameterValues
        self.defaultValue = defaultValue
        if let defaultValue = defaultValue {
            _text = State(initialValue: defaultValue)
        }
    }
    
    var body: some View {
        TextField("请输入文本", text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .onChange(of: text, initial: false) { oldValue, newValue in
                parameterValues.setValue(newValue, forKey: keyPath)
            }
            .onAppear {
                text = parameterValues.getValue(forKey: keyPath, as: String.self) ?? ""
            }
    }
}

// 整数输入
struct IntInputView: View {
    let keyPath: String
    @ObservedObject var parameterValues: ParameterValues
    var defaultValue: Int?
    @State private var text: String = ""
    
    init(keyPath: String, parameterValues: ParameterValues, defaultValue: Int? = nil) {
        self.keyPath = keyPath
        self.parameterValues = parameterValues
        self.defaultValue = defaultValue
        if let defaultValue = defaultValue {
            _text = State(initialValue: "\(defaultValue)")
        }
    }
    
    var body: some View {
        TextField("请输入数字", text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.numberPad)
            .onChange(of: text, initial: false) { oldValud, newValue in
                if let intValue = Int(newValue) {
                    parameterValues.setValue(intValue, forKey: keyPath)
                }
            }
            .onAppear {
                if let value = parameterValues.getValue(forKey: keyPath, as: Int.self) {
                    text = String(value)
                }
            }
    }
}

// 浮点数输入
struct DoubleInputView: View {
    let keyPath: String
    @ObservedObject var parameterValues: ParameterValues
    var defaultValue: Double?
    @State private var text: String = ""
    
    init(keyPath: String, parameterValues: ParameterValues, defaultValue: Double? = nil) {
        self.keyPath = keyPath
        self.parameterValues = parameterValues
        self.defaultValue = defaultValue
        if let defaultValue = defaultValue {
            _text = State(initialValue: "\(defaultValue)")
        }
    }
    
    var body: some View {
        TextField("请输入小数", text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.decimalPad)
            .onChange(of: text, initial: false) { oldValud, newValue in
                if let doubleValue = Double(newValue) {
                    parameterValues.setValue(doubleValue, forKey: keyPath)
                }
            }
            .onAppear {
                if let value = parameterValues.getValue(forKey: keyPath, as: Double.self) {
                    text = String(value)
                }
            }
    }
}

// 布尔值输入
struct BoolInputView: View {
    let keyPath: String
    @ObservedObject var parameterValues: ParameterValues
    var defaultValue: Bool?
    @State private var isOn: Bool = false
    
    init(keyPath: String, parameterValues: ParameterValues, defaultValue: Bool? = nil) {
        self.keyPath = keyPath
        self.parameterValues = parameterValues
        self.defaultValue = defaultValue
        if let defaultValue = defaultValue {
            _isOn = State(initialValue: defaultValue)
        }
    }
    
    var body: some View {
        Toggle("", isOn: $isOn)
            .onChange(of: isOn, initial: false) { oldValue, newValue in
                parameterValues.setValue(newValue, forKey: keyPath)
            }
            .onAppear {
                isOn = parameterValues.getValue(forKey: keyPath, as: Bool.self) ?? defaultValue ?? false
            }
    }
}

// 自定义类型输入
struct CustomTypeInputView: View {
    let parameter: APIParameter
    @ObservedObject var parameterValues: ParameterValues
    let keyPath: String
    @State private var isExpanded: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                    Text("展开自定义类型字段")
                        .font(.subheadline)
                    Spacer()
                }
                .foregroundColor(.blue)
            }
            
            if isExpanded, let customFields = parameter.customTypeFields {
                VStack(spacing: 12) {
                    ForEach(customFields, id: \.name) { field in
                        ParameterInputView(
                            parameter: field,
                            parameterValues: parameterValues,
                            keyPath: "\(keyPath).\(field.name)"
                        )
                    }
                }
                .padding(.leading, 16)
            }
        }
    }
}

#Preview {
    ExecutionView(item: FunctionViewListItem.init(
        FunctionViewTabType.localConversation,
        itemType: FunctionViewLocalConversationItemType.localConversation.rawValue,
        itemContent: "登录"
    ), onSwitchView: {})
}

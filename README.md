# nim-ios-samples-
云信IMV2 iOS SDK 示例代码

## 使用说明
1. 要有云信的AppKey，账号和密码。
2. 在`NIMConstant.swift`中填入自己的`AppKey`。
3. 运行后输入账号密码即可登录。

## 代码结构
- nim-ios-samples/nim-ios-samples/Classes/
```
├── Utils/                              # 工具类目录
│   ├── Logger.swift                    # 日志工具类
│   ├── MediaUtil.swift                 # 媒体工具类
│   └── DirectoryUtil.swift             # 目录工具类
├── Constants/                          # 常量定义目录  
│   └── NIMConstant.swift              # NIM相关常量，如AppKey
├── Category/                           # 扩展类目录
│   ├── String+Util.swift              # String扩展工具
│   ├── Data+Util.swift                # Data扩展工具
│   └── Dictionary+Util.swift          # Dictionary扩展工具
└── Pages/                             # 页面模块目录
    ├── Login/                         # 登录模块
    │   └── LoginView.swift            # 登录视图
    ├── Execution/                     # 执行模块
    │   ├── Extension/                 # 执行模块用到的扩展，一般为NIM类型的扩展
    │   ├── ExecutionModel.swift       # 执行模块数据模型
    │   ├── ExecutionViewModel/        # 执行模块视图模型目录，根据不同功能模块又分为不同的ViewModel
    │   └── ExecutionView.swift        # 执行模块视图
    ├── Function/                      # 功能模块，分功能模块展示API列表
    │   ├── FunctionView.swift         # 功能视图
    │   ├── FunctionViewModel.swift    # 功能视图模型
    │   └── FunctionModel.swift        # 功能数据模型
    ├── MainPage.swift                 # 主页面
    ├── ContentView.swift              # 内容视图
    └── ContentModel.swift             # 内容数据模型
```

- nim-ios-samples/nim-ios-samples/Classes/Pages/Execution/ExecutionViewModel/
```
├── ExecutionViewModels.swift							# 工厂类，决定由哪个实现类提供数据
├── ExecutionLoginViewModels.swift						# 登录实现类
├── ExecutionMessageViewModels.swift					# 消息实现类
├── ExecutionLocalConversationViewModels.swift			# 本地会话实现类
├── ExecutionFriendViewModels.swift						# 好友实现类
├── ExecutionUserViewModels.swift						# 用户实现类
└── ExecutionTeamViewModels.swift						# 群实现类
```
### Login模块
登录页面，输入账号和token登录IM。成功后，方可使用此应用。
登录成功后，进入Function模块；登录失败则停留在Login模块。

### Function模块
展示API列表。目前实现了对登录、消息、本地会话、好友、用户和群等核心API的调用，其中包括login和logout。
点击API列表中的一项，即可进入Execution模块。

### Execution模块
#### 页面介绍
Execution模块中通常有若干文本、输入框和一个执行按钮。
可以根据文本的描述，在输入框中填写参数，点击执行按钮，即可调用API。
#### 代码介绍
点击执行按钮时，会把输入框中的内容转换为一个dict（键值对）对象。执行部分解析此dict对象形成API参数，然后调用API。
组成界面和调用API的核心类型是`APIDefinition`，它有`name`、`parameters`、`executeFunction`三个字段。
其中，`name`是一个键；`parameters`描述了页面的组成方式和dict对象的结构；`executeFunction`是一个回调，负责解析dict对象和**执行API**
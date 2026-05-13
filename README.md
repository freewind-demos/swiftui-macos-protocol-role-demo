# SwiftUI macOS Protocol Role Demo

## 简介

这是 1 个专门讲 Swift / SwiftUI 里 `protocol` 的 macOS demo。

它同时演示 2 件事：

1. SwiftUI 里的 `View` 本身就是协议
2. 你也可以自己定义协议，让不同类型共用同 1 套界面和逻辑

## 快速开始

### 环境要求

- macOS 14+
- Xcode 15+
- XcodeGen

### 运行

```bash
cd /Users/peng.li/workspace/freewind-demos/swiftui-macos-protocol-role-demo
./scripts/build.sh
open ProtocolRoleDemo.xcodeproj
```

### 开发循环

```bash
cd /Users/peng.li/workspace/freewind-demos/swiftui-macos-protocol-role-demo
./dev.sh
```

## 注意事项

- 我这里把你的问题按“Swift/SwiftUI 里的协议”来解释
- 不展开讲网络协议、URLProtocol 那一类
- 先用最稳的“能力约定”版本帮你建立直觉

## 教程

### 1. protocol 是什么

`protocol` 可以理解成“约定”或“接口”。

它不关心你内部怎么实现，只规定：

- 你至少要提供哪些属性
- 你至少要提供哪些方法

谁遵守这个协议，谁就能被当成“有这项能力的东西”来使用。

### 2. SwiftUI 为什么也老出现 protocol

因为最常见的：

```swift
struct ContentView: View
```

这里的 `View` 就是协议。

意思不是“ContentView 继承了 1 个类”，而是：

- `ContentView` 承诺自己是 1 个 View
- 所以它必须提供 `body`

### 3. 这个 demo 怎么演示

我定义了 1 个自定义协议：

```swift
protocol DemoCardSpec {
  var title: String { get }
  var summary: String { get }
  func makeActionLine() -> String
}
```

然后做了 2 个完全不同的类型：

- `MeetingNoteCard`
- `BugTicketCard`

它们内部数据不同，但都遵守 `DemoCardSpec`。

所以同 1 个 `ProtocolCardView<Model: DemoCardSpec>` 能同时渲染它们。

### 4. 生动例子

把 `protocol` 想成公司招聘 JD：

- 只写“你要会什么”
- 不写“你必须长什么样”

只要候选人满足 JD：

- A 可以是产品经理
- B 可以是工程师

都能进同 1 套流程。

在代码里也是一样：

- `MeetingNoteCard` 长这样
- `BugTicketCard` 长那样

但只要都满足 `DemoCardSpec`，就能进同 1 个视图组件。

### 5. 关键体会

协议的价值不是“少写几个字”，而是：

1. 先定义能力边界
2. 再让不同实现接进来
3. 上层代码只依赖约定，不依赖具体类型细节

## 操作

1. 运行 app
2. 看左边 2 张卡片类型完全不同
3. 但它们都能走同 1 个 `ProtocolCardView`
4. 点按钮，看右边日志区生成不同行为
5. 再看顶部说明，体会 `View` 自己也是协议

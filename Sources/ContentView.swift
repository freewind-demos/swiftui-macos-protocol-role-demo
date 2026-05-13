import SwiftUI

// 这是主界面；注意这里的 `: View`，`View` 本身就是协议。
struct ContentView: View {
  // 这是日志列表。
  @State private var logs: [String] = []

  // 这是 1 个会议卡实例。
  private let meetingCard = MeetingNoteCard(
    id: "meeting",
    topic: "Popup 交互评审",
    decision: "搜索栏保留，预览支持直接编辑。"
  )

  // 这是 1 个缺陷卡实例。
  private let bugCard = BugTicketCard(
    id: "bug",
    ticketNo: "BUG-2417",
    issue: "回收站列表切换后焦点偶发丢失。"
  )

  // 组织整体布局。
  var body: some View {
    // 用纵向布局包住标题、双卡、说明区。
    VStack(alignment: .leading, spacing: 16) {
      // 顶部说明卡。
      headerCard

      // 中间左右分栏。
      HStack(alignment: .top, spacing: 16) {
        // 左边放两张卡片。
        cardsPanel

        // 右边放日志与讲解。
        logsPanel
      }
    }
    // 给页面留边距。
    .padding(20)
    // 给窗口最小尺寸。
    .frame(minWidth: 1180, minHeight: 780)
  }

  // 顶部说明卡。
  private var headerCard: some View {
    // 用卡片讲清核心结论。
    VStack(alignment: .leading, spacing: 10) {
      // 主标题。
      Text("protocol = 先写约定，再接不同实现")
        .font(.system(size: 28, weight: .bold))

      // 直接点破 SwiftUI 里的常见误区。
      Text("`struct ContentView: View` 里的 `View` 就是协议。你自己也能写协议，让完全不同的类型共用同 1 套界面和行为。")
        .foregroundStyle(.secondary)

      // 顶部标签。
      HStack(spacing: 10) {
        badge("View 也是 protocol")
        badge("协议 = 能力约定")
        badge("上层依赖约定，不依赖细节")
      }
    }
    // 卡片样式。
    .padding(18)
    .background(.thinMaterial)
    .clipShape(RoundedRectangle(cornerRadius: 16))
  }

  // 左边卡片区。
  private var cardsPanel: some View {
    // 用纵向卡片放两种不同类型。
    VStack(alignment: .leading, spacing: 16) {
      // 区标题。
      Text("左边：2 个不同类型，共用 1 套协议视图")
        .font(.headline)

      // 用同 1 个泛型视图渲染会议卡。
      ProtocolCardView(model: meetingCard) { line in
        // 追加日志。
        logs.insert(line, at: 0)
      }

      // 用同 1 个泛型视图渲染缺陷卡。
      ProtocolCardView(model: bugCard) { line in
        // 追加日志。
        logs.insert(line, at: 0)
      }

      // 补 1 段解释。
      insightCard(
        title: "为什么能共用",
        body: "因为 `ProtocolCardView` 不关心你是会议卡还是缺陷卡，它只认 `DemoCardSpec` 这份约定。"
      )
    }
    // 左栏样式。
    .padding(18)
    .frame(width: 520, alignment: .topLeading)
    .background(.regularMaterial)
    .clipShape(RoundedRectangle(cornerRadius: 16))
  }

  // 右边日志区。
  private var logsPanel: some View {
    // 用纵向布局包住说明与日志。
    VStack(alignment: .leading, spacing: 14) {
      // 区标题。
      Text("右边：协议带来的统一上层")
        .font(.headline)

      // 关键讲解 1。
      insightCard(
        title: "你现在看到的本质",
        body: "左边 2 个 model 内部字段完全不同，但只要都提供 `title / summary / actionTitle / accent / makeActionLine()`，同 1 套视图就能工作。"
      )

      // 关键讲解 2。
      insightCard(
        title: "为什么这很重要",
        body: "以后你要新增 `ImageTaskCard`、`ReleaseNoteCard`，只要遵守协议，就能直接复用这张卡片组件。"
      )

      // 日志标题。
      Text("操作日志")
        .font(.headline)

      // 日志滚动区。
      ScrollView {
        // 用纵向栈排列日志。
        LazyVStack(alignment: .leading, spacing: 10) {
          // 遍历日志。
          ForEach(Array(logs.enumerated()), id: \.offset) { _, line in
            // 渲染单行日志。
            Text(line)
              .font(.system(.body, design: .monospaced))
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(12)
              .background(Color.primary.opacity(0.04))
              .clipShape(RoundedRectangle(cornerRadius: 10))
          }
        }
      }
      // 没日志时给提示。
      .overlay {
        // 仅在空时显示提示。
        if logs.isEmpty {
          Text("点左边按钮，这里会显示不同实现各自产生的行为。")
            .foregroundStyle(.secondary)
        }
      }
    }
    // 右栏样式。
    .padding(18)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .background(.regularMaterial)
    .clipShape(RoundedRectangle(cornerRadius: 16))
  }

  // 构造说明卡片。
  private func insightCard(title: String, body: String) -> some View {
    // 用纵向布局放标题和正文。
    VStack(alignment: .leading, spacing: 8) {
      // 卡片标题。
      Text(title)
        .font(.headline)

      // 卡片正文。
      Text(body)
        .foregroundStyle(.secondary)
    }
    // 卡片样式。
    .padding(14)
    .background(Color.primary.opacity(0.04))
    .clipShape(RoundedRectangle(cornerRadius: 12))
  }

  // 顶部小标签。
  private func badge(_ text: String) -> some View {
    // 用胶囊承载说明。
    Text(text)
      .font(.caption.weight(.medium))
      .padding(.horizontal, 10)
      .padding(.vertical, 6)
      .background(Color.primary.opacity(0.06))
      .clipShape(Capsule())
  }
}

// 这是通用卡片视图；它不认具体类型，只认协议。
struct ProtocolCardView<Model: DemoCardSpec>: View {
  // 注入任意遵守协议的 model。
  let model: Model

  // 注入点击后的回调。
  let onAction: (String) -> Void

  // 组织卡片布局。
  var body: some View {
    // 用纵向布局包住所有信息。
    VStack(alignment: .leading, spacing: 12) {
      // 标题与类型说明。
      HStack {
        // 显示协议要求的标题。
        Text(model.title)
          .font(.title3.weight(.semibold))

        Spacer(minLength: 0)

        // 显示主题角标。
        Text(model.accent.rawValue)
          .font(.caption.weight(.medium))
          .padding(.horizontal, 8)
          .padding(.vertical, 4)
          .background(model.accent.color.opacity(0.12))
          .clipShape(Capsule())
      }

      // 显示协议要求的摘要。
      Text(model.summary)
        .foregroundStyle(.secondary)

      // 显示这张卡依赖的协议名。
      Text("这张卡只依赖 `DemoCardSpec`")
        .font(.caption)
        .foregroundStyle(.secondary)

      // 操作按钮。
      Button(model.actionTitle) {
        // 调用协议方法，生成动作结果。
        onAction(model.makeActionLine())
      }
      .tint(model.accent.color)
    }
    // 卡片样式。
    .padding(16)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(model.accent.color.opacity(0.07))
    .overlay(
      RoundedRectangle(cornerRadius: 14)
        .stroke(model.accent.color.opacity(0.22), lineWidth: 1)
    )
    .clipShape(RoundedRectangle(cornerRadius: 14))
  }
}

import SwiftUI

// 这是颜色 token，避免把 Color 直接塞进协议说明里讲复杂点。
enum DemoAccent: String {
  // 蓝色主题。
  case blue

  // 红色主题。
  case red

  // 根据 token 返回真实颜色。
  var color: Color {
    // 按 case 返回颜色。
    switch self {
    case .blue:
      return .blue
    case .red:
      return .red
    }
  }
}

// 这是自定义协议，表达“能被同 1 张卡片渲染”的能力约定。
protocol DemoCardSpec {
  // 每张卡的稳定 id。
  var id: String { get }

  // 卡片标题。
  var title: String { get }

  // 卡片摘要。
  var summary: String { get }

  // 操作按钮文案。
  var actionTitle: String { get }

  // 主题色 token。
  var accent: DemoAccent { get }

  // 生成 1 行操作日志。
  func makeActionLine() -> String
}

// 这是“会议纪要”类型。
struct MeetingNoteCard: DemoCardSpec {
  // 稳定 id。
  let id: String

  // 会议主题。
  let topic: String

  // 会议结论。
  let decision: String

  // 协议要求的标题。
  var title: String {
    // 组合成标题。
    "会议：\(topic)"
  }

  // 协议要求的摘要。
  var summary: String {
    // 返回结论摘要。
    decision
  }

  // 协议要求的按钮文案。
  var actionTitle: String {
    // 返回动作名字。
    "生成纪要行"
  }

  // 协议要求的主题色。
  var accent: DemoAccent {
    // 会议卡用蓝色。
    .blue
  }

  // 协议要求的方法实现。
  func makeActionLine() -> String {
    // 返回 1 行日志。
    "会议纪要已生成：\(topic) → \(decision)"
  }
}

// 这是“缺陷工单”类型。
struct BugTicketCard: DemoCardSpec {
  // 稳定 id。
  let id: String

  // 工单编号。
  let ticketNo: String

  // 缺陷描述。
  let issue: String

  // 协议要求的标题。
  var title: String {
    // 组合成标题。
    "缺陷：\(ticketNo)"
  }

  // 协议要求的摘要。
  var summary: String {
    // 返回问题摘要。
    issue
  }

  // 协议要求的按钮文案。
  var actionTitle: String {
    // 返回动作名字。
    "生成缺陷行"
  }

  // 协议要求的主题色。
  var accent: DemoAccent {
    // 缺陷卡用红色。
    .red
  }

  // 协议要求的方法实现。
  func makeActionLine() -> String {
    // 返回 1 行日志。
    "缺陷工单已创建：\(ticketNo) → \(issue)"
  }
}

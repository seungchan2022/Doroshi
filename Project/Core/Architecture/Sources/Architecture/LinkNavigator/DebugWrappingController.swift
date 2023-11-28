import Foundation
import LinkNavigator
import UIKit
import SwiftUI

public final class DebugWrappingController<Content: View>: UIHostingController<Content>, MatchPathUsable {


  // MARK: Lifecycle

  public init(
    matchPath: String,
    eventSubscriber: LinkNavigatorItemSubscriberProtocol? = .none,
    @ViewBuilder content: () -> Content)
  {
    self.matchPath = matchPath
    self.eventSubscriber = eventSubscriber
    super.init(rootView: content())
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    print("✂️ \(matchPath) deinit...")
  }

  // MARK: Public

  public let matchPath: String
  public let eventSubscriber: LinkNavigatorItemSubscriberProtocol?

  public override func viewDidLoad() {
    super.viewDidLoad()
    print("🚗 \(matchPath)")
  }
}

//
//  UIEdgeInsets+SwiftUI.swift
//  TestGame
//
//  Created by Nikolai Lipski on 10.03.24.
//

import UIKit
import SwiftUI

struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        (UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets ?? .zero).insets
    }
}

extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

extension UIEdgeInsets {
    var insets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}

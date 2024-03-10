//
//  Range+Ext.swift
//  TestGame
//
//  Created by Nikolai Lipski on 10.03.24.
//

import Foundation

extension ClosedRange where Bound: FixedWidthInteger  {
    var random: Bound { .random(in: self) }
    func random(_ n: Int) -> [Bound] { (0..<n).map { _ in random } }
}

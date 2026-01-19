//
//  ViewExtensions.swift
//  KineTipsBaby
//
//  Created on 2026
//

import SwiftUI

extension View {
    @ViewBuilder
    func navigationBarTitleDisplayModeInline() -> some View {
        #if os(iOS)
        self.navigationBarTitleDisplayMode(.inline)
        #else
        self
        #endif
    }
}

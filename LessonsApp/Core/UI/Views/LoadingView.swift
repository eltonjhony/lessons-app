//
//  LoadingView.swift
//  LessonsApp
//
//  Created by Elton Jhony on 03/03/23.
//

import Foundation
import SwiftUI

struct LoadingView<Content>: View where Content: View {
    var isShowing: Bool
    var content: () -> Content

    var body: some View {
        ZStack(alignment: .center) {
            content()
                .disabled(isShowing)
                .blur(radius: isShowing ? 3 : 0)
            if isShowing {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
    }

}

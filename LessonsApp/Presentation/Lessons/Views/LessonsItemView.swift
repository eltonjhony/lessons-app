//
//  LessonsItemView.swift
//  LessonsApp
//
//  Created by Elton Jhony on 03/03/23.
//

import Foundation
import SwiftUI

struct LessonsItemView: View {
    let item: LessonModel

    var body: some View {
        HStack(alignment: .center) {
            URLImage(url: item.thumbnail.url)
                .frame(width: 80, height: 50)
                .cornerRadius(4)
            Text(item.name)
                .multilineTextAlignment(.leading)
                .font(.headline)
            Spacer(minLength: 16)
            Image(systemName: "chevron.right")
        }
        .padding()
        .accessibility(identifier: "\(Accessibility.Views.lessonCellIdentifier)\(item.id)")
    }
}

private extension String {
    var url: URL? {
        URL(string: self)
    }
}

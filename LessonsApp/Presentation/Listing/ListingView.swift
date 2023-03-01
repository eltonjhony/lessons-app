//
//  ListingView.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation
import SwiftUI

struct ListingView<Presenter: ListingPresentable>: View {
    @ObservedObject var presenter: Presenter

    var body: some View {
        ScrollView {
            ForEach(presenter.lessons, id: \.id) { lesson in
                ListingItem(item: lesson)
                    .onTapGesture(perform: presenter.detailsTapped)
            }
        }.padding(.top)
    }
    
}

private struct ListingItem: View {
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
    }
}

private extension String {
    var url: URL? {
        URL(string: self)
    }
}

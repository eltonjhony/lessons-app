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
        LoadingView(isShowing: presenter.data == .loading) {
            content
        }
    }

    @ViewBuilder
    private var content: some View {
        if case let .success(lessons) = presenter.data {
            ScrollView {
                ForEach(lessons, id: \.id) { lesson in
                    ListingItem(item: lesson)
                        .onTapGesture {
                            presenter.detailsTapped(id: lesson.id)
                        }
                }
            }.padding(.top)
        }
    }

}

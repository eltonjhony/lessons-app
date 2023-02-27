//
//  SUIImagePresenter.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation
import SwiftUI

public final class SUIImagePresenter: ObservableObject {

    public let wrapped: ImagePresentable?

    public init(presenter: ImagePresentable?) {
        wrapped = presenter
    }
}

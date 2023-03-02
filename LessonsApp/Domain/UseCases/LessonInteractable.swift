//
//  LessonInteractable.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation
import Combine

public protocol LessonInteractable {
    var lessons: AnyPublisher<[LessonModel], Never> { get }

    func fetchLessons()
    func getById(_ id: Int) -> AnyPublisher<LessonModel?, Never>
}

public final class LessonInteractor: LessonInteractable {
    public var lessons: AnyPublisher<[LessonModel], Never> {
        lessonsSubject.eraseToAnyPublisher()
    }
    private var lessonsSubject: CurrentValueSubject<[LessonModel], Never> = .init([])

    private let lessonRepository: LessonRepositoryProtocol

    private var cancellables = [AnyCancellable]()

    public init(lessonRepository: LessonRepositoryProtocol) {
        self.lessonRepository = lessonRepository
    }

    public func fetchLessons() {
        lessonRepository.fetchAll()
            .sink { _ in } receiveValue: { [weak self] lessons in
                self?.lessonsSubject.send(lessons)
            }.store(in: &cancellables)
    }

    public func getById(_ id: Int) -> AnyPublisher<LessonModel?, Never> {
        lessonRepository.getById(id)
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}

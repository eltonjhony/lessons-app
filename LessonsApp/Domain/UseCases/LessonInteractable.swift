//
//  LessonInteractable.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation
import Combine

public enum LessonsData: Equatable {
    case idle
    case error
    case success([LessonModel])
    case loading
}

public protocol LessonInteractable {
    var lessonsData: AnyPublisher<LessonsData, Never> { get }

    func fetchLessons()
    func getById(_ id: Int) -> AnyPublisher<LessonModel?, Never>
}

public final class LessonInteractor: LessonInteractable {
    public var lessonsData: AnyPublisher<LessonsData, Never> {
        lessonsDataSubject.eraseToAnyPublisher()
    }
    private var lessonsDataSubject: CurrentValueSubject<LessonsData, Never> = .init(.idle)

    private let lessonRepository: LessonRepositoryProtocol

    private var cancellables = [AnyCancellable]()

    public init(lessonRepository: LessonRepositoryProtocol) {
        self.lessonRepository = lessonRepository
    }

    public func fetchLessons() {
        lessonsDataSubject.send(.loading)
        lessonRepository.fetchAll()
            .sink { [weak self] completion in
                guard case .failure = completion else { return }
                self?.lessonsDataSubject.send(.error)
            } receiveValue: { [weak self] lessons in
                self?.lessonsDataSubject.send(.success(lessons))
            }.store(in: &cancellables)
    }

    public func getById(_ id: Int) -> AnyPublisher<LessonModel?, Never> {
        lessonRepository.getById(id)
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}

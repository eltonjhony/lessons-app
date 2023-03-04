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

    var detailsData: AnyPublisher<LessonModel?, Never> { get }
    var nextLessonAvailable: AnyPublisher<Bool, Never> { get }

    func fetchLessons()
    func getById(_ id: Int)
    func getNextLesson(_ id: Int)
}

public final class LessonInteractor: LessonInteractable {
    public var lessonsData: AnyPublisher<LessonsData, Never> {
        lessonsDataSubject.eraseToAnyPublisher()
    }
    private var lessonsDataSubject: CurrentValueSubject<LessonsData, Never> = .init(.idle)

    public var detailsData: AnyPublisher<LessonModel?, Never> {
        detailsDataSubject.eraseToAnyPublisher()
    }
    private var detailsDataSubject: CurrentValueSubject<LessonModel?, Never> = .init(nil)

    public var nextLessonAvailable: AnyPublisher<Bool, Never> {
        nextLessonAvailableSubject.eraseToAnyPublisher()
    }
    private var nextLessonAvailableSubject: PassthroughSubject<Bool, Never> = .init()

    private let lessonRepository: LessonRepositoryProtocol

    private var cancellables = [AnyCancellable]()

    public init(lessonRepository: LessonRepositoryProtocol) {
        self.lessonRepository = lessonRepository
    }

    public func fetchLessons() {
        lessonsDataSubject.send(.loading)
        lessonRepository.fetchAll().sink { [weak self] completion in
            guard case .failure = completion else { return }
            self?.lessonsDataSubject.send(.error)
        } receiveValue: { [weak self] lessons in
            self?.lessonsDataSubject.send(.success(lessons))
        }.store(in: &cancellables)
    }

    public func getById(_ id: Int) {
        lessonRepository.getById(id)
            .replaceError(with: nil)
            .sink(receiveValue: { [weak self] model in
                self?.detailsDataSubject.send(model)
                if let id = model?.id {
                    self?.nextLessonAvailableSubject.send(
                        self?.lessonRepository.lessonIds.after(id) != nil
                    )
                } else {
                    self?.nextLessonAvailableSubject.send(false)
                }
            })
            .store(in: &cancellables)
    }

    public func getNextLesson(_ id: Int) {
        if let nextId = lessonRepository.lessonIds.after(id) {
            getById(nextId)
        }
    }
}

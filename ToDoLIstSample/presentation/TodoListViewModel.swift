//
//  TodoListViewModel.swift
//  ToDoLIstSample
//
//  Created by Masafumi Abe on 2020/09/17.
//

import Foundation
import RxCocoa
import RxSwift

class TodoListViewModel {
    
    private let createTodoUseCase: CreateTodoUseCase
    private let completeTodoUseCase: CompleteTodoUseCase
    private let deleteTodoUseCase: DeleteTodoUseCase
    private let uncompleteTodoUseCase: UncompleteTodoUseCase
    private let fetchAllTodosUseCase: FetchAllTodosUseCase
    
    private let queue = DispatchQueue.global(qos: .userInteractive)
    
    private let _todoList = BehaviorSubject<[TodoListSectionData]>(value: TodoListSectionData.empty())
    var todoList: Driver<[TodoListSectionData]>  {
        return _todoList.asDriver(onErrorDriveWith: .empty())
    }
    
    private let _toolBarState = BehaviorSubject<TodoListToobarState>(value: .idle)
    var toolBarState: Driver<TodoListToobarState> {
        return _toolBarState.asDriver(onErrorDriveWith: .empty())
    }
    
    private let _state = BehaviorSubject<TodoListState>(value: .idle)
    var state: Driver<TodoListState> {
        return _state.asDriver(onErrorDriveWith: .empty())
    }
    
    init(
        createTodoUseCase: CreateTodoUseCase,
        completeTodoUseCase: CompleteTodoUseCase,
        deleteTodoUseCase: DeleteTodoUseCase,
        uncompleteTodoUseCase: UncompleteTodoUseCase,
        fetchAllTodosUseCase: FetchAllTodosUseCase
    ) {
        self.createTodoUseCase = createTodoUseCase
        self.completeTodoUseCase = completeTodoUseCase
        self.deleteTodoUseCase = deleteTodoUseCase
        self.uncompleteTodoUseCase = uncompleteTodoUseCase
        self.fetchAllTodosUseCase = fetchAllTodosUseCase
    }
    
    func load() {
        queue.async { [unowned self] in
            let todoList = self.fetchAllTodosUseCase.handle()
                .sorted { $0.createdAt > $1.createdAt }
            let notCompletedList = todoList.filter { $0.state == .notCompleted }
            let completedList = todoList.filter { $0.state == .completed }
            _todoList.onNext(TodoListSectionData.sections(notCompleted: notCompletedList, completed: completedList))
        }
    }
    
    func addTodo(name: String) {
        queue.async { [unowned self] in
            let _ = self.createTodoUseCase.handle(title: name)
            self._toolBarState.onNext(.idle)
            self._state.onNext(.added)
            self.load()
        }
    }
    
    func onTaskNameInputed(taskName: String) {
        _toolBarState.onNext(.editing(canAdd: !taskName.isEmpty))
    }
    
    func complete(index: Int) {
        reloadAfter { [unowned self] todoList in
            let todo = todoList[0].items[index]
            self.completeTodoUseCase.handle(id: todo.id)
        }
    }
    
    func uncomplete(index: Int) {
        reloadAfter { [unowned self] todoList in
            let todo = todoList[1].items[index]
            self.uncompleteTodoUseCase.handle(id: todo.id)
        }
    }
    
    func delete(path: IndexPath) {
        reloadAfter { [unowned self] todoList in
            let todo = todoList[path.section].items[path.row]
            self.deleteTodoUseCase.handle(id: todo.id)
        }
    }
    
    private func reloadAfter(action: @escaping ([TodoListSectionData]) -> ()) {
        queue.async { [unowned self] in
            guard let current = try? self._todoList.value() else {
                return
            }
            action(current)
            self.load()
        }

    }
    
}

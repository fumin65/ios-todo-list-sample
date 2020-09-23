//
//  SwinjectStoryboard+Setup.swift
//  ToDoLIstSample
//
//  Created by Masafumi Abe on 2020/09/20.
//

import SwinjectStoryboard

extension SwinjectStoryboard {
    class func setup() {
        defaultContainer.register(Database.self) { _ in Database() }
            .inObjectScope(.container)
        
        defaultContainer.register(TodoRepository.self) { CoreDataTodoRepository(database: $0.resolve(Database.self)!)  }
        
        defaultContainer.register(CreateTodoUseCase.self) { CreateTodoUseCase(todoRepository: $0.resolve(TodoRepository.self)!) }
        defaultContainer.register(CompleteTodoUseCase.self) { CompleteTodoUseCase(todoRepository: $0.resolve(TodoRepository.self)!) }
        defaultContainer.register(DeleteTodoUseCase.self) { DeleteTodoUseCase(todoRepository: $0.resolve(TodoRepository.self)!) }
        defaultContainer.register(UncompleteTodoUseCase.self) { UncompleteTodoUseCase(todoRepository: $0.resolve(TodoRepository.self)!) }
        defaultContainer.register(FetchAllTodosUseCase.self) { FetchAllTodosUseCase(todoRepository: $0.resolve(TodoRepository.self)!) }
        
        defaultContainer.register(TodoListViewModel.self) {
            TodoListViewModel(
                createTodoUseCase: $0.resolve(CreateTodoUseCase.self)!,
                completeTodoUseCase: $0.resolve(CompleteTodoUseCase.self)!,
                deleteTodoUseCase: $0.resolve(DeleteTodoUseCase.self)!,
                uncompleteTodoUseCase: $0.resolve(UncompleteTodoUseCase.self)!,
                fetchAllTodosUseCase: $0.resolve(FetchAllTodosUseCase.self)!
            )
        }
        
        defaultContainer.storyboardInitCompleted(UINavigationController.self) { _, _ in  }
        defaultContainer.storyboardInitCompleted(TodoListViewController.self) {
            $1.viewModel = $0.resolve(TodoListViewModel.self)
        }
        
        
    }
}

//
//  FetchAllTodosUseCase.swift
//  ToDoLIstSample
//
//  Created by Masafumi Abe on 2020/09/18.
//

import Foundation

class FetchAllTodosUseCase {
    
    private let todoRepository: TodoRepository
    
    init(todoRepository: TodoRepository) {
        self.todoRepository = todoRepository
    }
    
    func handle() -> [TodoData] {
        return todoRepository.allTodos().map(TodoData.init(from:))
    }
    
}

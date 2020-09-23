//
//  UncompleteTodoUseCase.swift
//  ToDoLIstSample
//
//  Created by Masafumi Abe on 2020/09/18.
//

import Foundation

class UncompleteTodoUseCase {
    
    private let todoRepository: TodoRepository
    
    init(todoRepository: TodoRepository) {
        self.todoRepository = todoRepository
    }
    
    func handle(id: String) {
        guard let todo = todoRepository.todo(of: TodoId(value: id)) else {
            return
        }
        todo.uncomplete()
        todoRepository.save(todo: todo)
    }
    
}

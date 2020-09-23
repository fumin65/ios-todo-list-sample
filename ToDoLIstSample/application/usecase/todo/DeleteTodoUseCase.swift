//
//  DeleteTodoUseCase.swift
//  ToDoLIstSample
//
//  Created by Masafumi Abe on 2020/09/18.
//

import Foundation

class DeleteTodoUseCase {
    
    private let todoRepository: TodoRepository
    
    init(todoRepository: TodoRepository) {
        self.todoRepository = todoRepository
    }
    
    func handle(id: String) {
        if let todo = todoRepository.todo(of: TodoId(value: id)) {
            todoRepository.delete(todo: todo)
        }
    }
    
}

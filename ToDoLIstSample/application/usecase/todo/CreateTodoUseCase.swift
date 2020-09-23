//
//  CreateTodoUseCase.swift
//  ToDoLIstSample
//
//  Created by Masafumi Abe on 2020/09/18.
//

import Foundation

class CreateTodoUseCase {
    
    private let todoRepository: TodoRepository
    
    init(todoRepository: TodoRepository) {
        self.todoRepository = todoRepository
    }
    
    func handle(title: String) -> TodoData {
        let id = todoRepository.id()
        let todo = Todo(id: id, title: title)
        todoRepository.insert(todo: todo)
        return TodoData(from: todo)
    }
    
}

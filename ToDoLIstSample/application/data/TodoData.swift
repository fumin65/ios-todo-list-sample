//
//  TodoData.swift
//  ToDoLIstSample
//
//  Created by Masafumi Abe on 2020/09/20.
//

import Foundation

struct TodoData : Equatable {
    let id: String
    let title: String
    let createdAt: Date
    let state: Todo.State
}

extension TodoData {
    
    init(from todo: Todo) {
        self.init(id: todo.id.value, title: todo.title, createdAt: todo.createdAt, state: todo.state)
    }
    
}

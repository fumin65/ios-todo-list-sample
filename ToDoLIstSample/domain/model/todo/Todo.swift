//
//  Todo.swift
//  ToDoLIstSample
//
//  Created by Masafumi Abe on 2020/09/17.
//

import Foundation

class Todo {
    
    enum State : Int16 {
        case completed = 0, notCompleted
    }
    
    let id: TodoId
    var title: String
    private (set) var state: State
    let createdAt: Date
    
    init(id: TodoId, title: String, state: State, createdAt: Date) {
        self.id = id
        self.title = title
        self.state = state
        self.createdAt = createdAt
    }
    
    convenience init(id: TodoId, title: String) {
        self.init(id: id, title: title, state: .notCompleted, createdAt: Date())
    }
    
    func complete()  {
        if state == .notCompleted {
            state = .completed
        }
    }
    
    func uncomplete() {
        if state == .completed {
            state = .notCompleted
        }
    }
    
}

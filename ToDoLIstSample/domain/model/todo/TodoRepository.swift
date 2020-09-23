//
//  TodoRepository.swift
//  ToDoLIstSample
//
//  Created by Masafumi Abe on 2020/09/17.
//

import Foundation

protocol TodoRepository : AnyObject {
    
    func allTodos() -> [Todo]
    
    func todo(of id: TodoId) -> Todo?
    
    func insert(todo: Todo)
    
    func save(todo: Todo)
    
    func delete(todo: Todo)
    
    func id() -> TodoId
    
}

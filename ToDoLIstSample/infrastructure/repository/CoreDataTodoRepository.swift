//
//  CoreDataTodoRepository.swift
//  ToDoLIstSample
//
//  Created by Masafumi Abe on 2020/09/17.
//

import UIKit
import CoreData

class CoreDataTodoRepository : TodoRepository {
    
    private let database: Database
    
    init(database: Database) {
        self.database = database
    }
    
    func allTodos() -> [Todo] {
        return database.fetchAll().map { (dto: TodoDto) in toModel(dto) }
    }
    
    func delete(todo: Todo) {
        database.delete(at: NSPredicate(format: "id = %@", todo.id.value), type: TodoDto.self)
    }
    
    func insert(todo: Todo) {
        database.insert { (dto: TodoDto) in
            dto.id = todo.id.value
            dto.title = todo.title
            dto.createdAt = todo.createdAt
            dto.state = todo.state.rawValue
        }
    }
    
    func save(todo: Todo) {
        let predicate = NSPredicate(format: "id = %@", todo.id.value)
        database.update(at: predicate) { (dto: TodoDto) in
            dto.state = todo.state.rawValue
            dto.title = todo.title
            dto.createdAt = todo.createdAt
        }
    }
    
    func todo(of id: TodoId) -> Todo? {
        if let dto: TodoDto = database.fetch(by: NSPredicate(format: "id = %@", id.value)) {
            return toModel(dto)
        }
        return nil
    }
    
    func id() -> TodoId {
        return TodoId(value: UUID().uuidString)
    }
    
    private func toModel(_ dto: TodoDto) -> Todo {
        return Todo(
            id: TodoId(value: dto.id!),
            title: dto.title!,
            state: Todo.State.init(rawValue: dto.state)!,
            createdAt: dto.createdAt!
        )
    }
    
}

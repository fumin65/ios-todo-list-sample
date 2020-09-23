//
//  TodoListSectionData.swift
//  ToDoLIstSample
//
//  Created by Masafumi Abe on 2020/09/21.
//

import Foundation
import RxDataSources

extension TodoData : IdentifiableType {
    typealias Identity = String
    var identity: String {
        return id
    }
}

enum TodoListSection : IdentifiableType {
    
    typealias Identity = TodoListSection
    var identity: TodoListSection {
        return self
    }
    
    case notCompleted, completed
    
}

typealias TodoListSectionData = AnimatableSectionModel<TodoListSection, TodoData>

extension TodoListSectionData {
    
    static func empty() -> [TodoListSectionData] {
        return [
            TodoListSectionData(model: .notCompleted, items: []),
            TodoListSectionData(model: .completed, items: [])
        ]
    }
    
    static func sections(notCompleted: [TodoData], completed: [TodoData]) -> [TodoListSectionData] {
        return [
            TodoListSectionData(model: .notCompleted, items: notCompleted),
            TodoListSectionData(model: .completed, items: completed)
        ]
    }
    
}

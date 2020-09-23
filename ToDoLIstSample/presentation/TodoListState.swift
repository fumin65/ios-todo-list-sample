//
//  TodoListState.swift
//  ToDoLIstSample
//
//  Created by Masafumi Abe on 2020/09/23.
//

import Foundation

enum TodoListState {
    case idle
    case added
}

enum TodoListToobarState {
    case idle
    case editing(canAdd: Bool)
}

//
//  ViewController.swift
//  ToDoLIstSample
//
//  Created by Masafumi Abe on 2020/09/16.
//

import UIKit
import RxSwift
import RxDataSources

class TodoListViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet var todoListView: UITableView!
    @IBOutlet weak var taskNameField: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var toolBar: UIView!
    
    var viewModel: TodoListViewModel?
    
    private let dataSource = RxTableViewSectionedAnimatedDataSource<TodoListSectionData>(
        animationConfiguration: AnimationConfiguration(
            insertAnimation: .fade,
            reloadAnimation: .none,
            deleteAnimation: .fade
        ),
        configureCell: { dataSource, tableView, index, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: index) as! TodoCell
            let attribute = NSMutableAttributedString(string: item.title)
            
            if item.state == .completed {
                attribute.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attribute.length))
            }
            
            cell.titleView.attributedText = attribute
            
            return cell
        },
        titleForHeaderInSection: { dataSource, index in
            
            if dataSource[index].items.isEmpty {
                return nil
            }
            
            let section = dataSource[index].model
            if section == .completed {
                return NSLocalizedString("sectionCompleted", comment: "completed section title")
            } else {
                return NSLocalizedString("sectionNotCompleted", comment: "incomplete section title")
            }
        },
        canEditRowAtIndexPath: { _, _ in true }
    )
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.todoList
            .drive(todoListView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel?.toolBarState
            .drive(onNext: { [unowned self] state in
                switch state {
                case .idle:
                    self.addBtn.isEnabled = false
                    self.taskNameField.text = ""
                case let .editing(canAdd):
                    self.addBtn.isEnabled = canAdd
                }
            })
            .disposed(by: disposeBag)
        
        viewModel?.state
            .drive(onNext: { [unowned self] state in
                if state == .added {
                    self.todoListView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        
        taskNameField.rx
            .controlEvent(.editingChanged)
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                self.viewModel?.onTaskNameInputed(taskName: self.taskNameField.text ?? "")
            })
            .disposed(by: disposeBag)
        
        todoListView.delegate = self
            
        viewModel?.load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(keyboardWillApper(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(keyboardWillDisapper(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let nc = NotificationCenter.default
        nc.removeObserver(self)
    }
    
    @objc private func keyboardWillApper(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo as? [String : Any] else {
            return
        }
        guard  let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        guard let keyboardAnimDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        let keyboardSize = keyboardInfo.cgRectValue.size
        let safeAreaHeight = self.view.safeAreaInsets.bottom
        UIView.animate(withDuration: keyboardAnimDuration) {
            self.toolBar.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height + safeAreaHeight)
        }
    }
    
    @objc private func keyboardWillDisapper(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo as? [String : Any] else {
            return
        }
        guard let keyboardAnimDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        UIView.animate(withDuration: keyboardAnimDuration) {
            self.toolBar.transform = .identity
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideKeyboard()
    }
    
    
    @IBAction func addOnClick(_ sender: Any) {
        if let title = taskNameField.text, !title.isEmpty {
            viewModel?.addTodo(name: title)
            hideKeyboard()
        }
    }
    
    private func hideKeyboard() {
        if taskNameField.isFirstResponder {
            taskNameField.resignFirstResponder()
        }
    }
 
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let complete = UIContextualAction(style: .normal, title: NSLocalizedString("completeTodo", comment: "complete button text")) { [unowned self]  _, _, handler in
            self.viewModel?.complete(index: indexPath.row)
            handler(true)
        }
        let uncomplete = UIContextualAction(style: .normal, title: NSLocalizedString("uncompleteTodo", comment: "uncomplete button text")) { [unowned self]  _, _, handler in
            self.viewModel?.uncomplete(index: indexPath.row)
            handler(true)
        }
        let delete = UIContextualAction(style: .destructive, title: NSLocalizedString("deleteTodo", comment: "delete button text")) { [unowned self]  _, _, handler in
            self.viewModel?.delete(path: indexPath)
            handler(true)
        }
        
        complete.backgroundColor = UIColor.green
        uncomplete.backgroundColor = UIColor.green
        
        let actions: [UIContextualAction]
        if indexPath.section == 0 {
            actions = [complete, delete]
        } else {
            actions = [uncomplete, delete]
        }
        
        let configuration = UISwipeActionsConfiguration(actions: actions)
        configuration.performsFirstActionWithFullSwipe = true
        
        return configuration
    }

}


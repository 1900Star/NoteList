//
//  ViewController.swift
//  Table Demo
//
//  Created by 罗诗朋 on 2021/7/22.
//

import UIKit

class TableVC: UIViewController {
    
    var list : [String] = ["东","西","南","北"]

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   // tableView进入编辑状态
    @IBAction func clickReorderButton(_ sender: UIBarButtonItem) {
        
        tableView.isEditing.toggle()
        
        
    }
    // 点击添加按钮
    @IBAction func clickAddButton(_ sender: UIBarButtonItem) {
        goToEdit(index: nil)
    }
    
    // 打开编辑界面
    func goToEdit(index: Int?){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
       let vc =  storyboard.instantiateViewController(withIdentifier: "item") as! EditVC
        vc.delegate = self
        if let index = index {
            vc.index = index
            vc.text = list[index]
        }
        
        navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
}
extension TableVC: UITableViewDataSource {
    

    // 列表的长度
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    // 从数据里面取出数据
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item",for: indexPath)
//        cell.textLabel?.text = indexPath.row % 2 == 0 ? list[indexPath.row] : "AA"
        let aa = list[indexPath.row]
        print("Item Text Content \(aa)  index \(indexPath.row)")
        cell.textLabel?.text = list[indexPath.row]
        return cell
    }
// 列表排序
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let str =  list.remove(at: sourceIndexPath.row)
        list.insert(str, at: destinationIndexPath.row)
        
    }
    
}

extension TableVC: UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        goToEdit(index: indexPath.row)
        
    }
    // 左滑删出Item
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        UISwipeActionsConfiguration(actions: [
            UIContextualAction(style: .destructive, title: "Delete", handler: {_,_,completion in
                self.list.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                
                // 滑动第二个Item,之前的滑动的Item自动回到默认状态
                completion(true)
            })
        ])
    }
    
    // 进入排序状态隐藏删除按钮
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        .none
    }
    // 去掉删除按钮所占的空间
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
}

extension TableVC: EditVCDelegate{
   
    func editVC(_ vc: EditVC, didSave text: String, index: Int?) {
        if let index = index {
            list[index] = text
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }else {
            list.insert(text, at: list.count)
            tableView.insertRows(at: [IndexPath(row: list.count-1, section: 0)], with: .automatic)
            
            
        }
    }
    
}

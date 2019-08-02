//
//  SearchViewController.swift
//  WritingScan
//
//  Created by 郑红 on 2019/8/1.
//  Copyright © 2019 com.zhenghong. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    private var tableView: UITableView!
    fileprivate var data: [Words] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: view.bounds, style: .plain);
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "word-cell")
        view.addSubview(tableView)
    }
    
    func reloadData(data: [Words]) {
        self.data = data
        tableView.reloadData()
    }

}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "word-cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].words
        return cell
    }
}
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

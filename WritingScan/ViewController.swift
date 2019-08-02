//
//  ViewController.swift
//  WritingScan
//
//  Created by 郑红 on 2019/8/1.
//  Copyright © 2019 com.zhenghong. All rights reserved.
//

import UIKit
import AipOcrSdk

class ViewController: UIViewController {
    @IBOutlet var scan: UIBarButtonItem!
    
    @IBOutlet var imageContainer: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var workTable: UITableView!
    fileprivate var searchController: UISearchController!
    fileprivate var searchResult: SearchViewController!
    fileprivate var wordArray: [Words] = []
    
    fileprivate var scanImage: UIImage?
    
    var cd: CD!
    var wordConetxt: WordsContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workTable.register(UITableViewCell.self, forCellReuseIdentifier: "work-cell")
        searchResult = SearchViewController()
        searchController = UISearchController(searchResultsController: searchResult)
        searchController.searchResultsUpdater = self
        workTable.tableHeaderView = searchController.searchBar
        imageContainer.isHidden = true
        
        cd = CD(completionClosure: {
           
        })
        wordConetxt = WordsContext(cd: cd)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @IBAction func tapGesture(_ sender: Any) {
        imageContainer.isHidden = true
    }
    @IBAction func scan(_ sender: Any) {
        searchController.searchBar.resignFirstResponder()
        let alert = UIAlertController(title: nil, message: "选择", preferredStyle: .actionSheet)
        let photo = UIAlertAction(title: "相册", style: .default) { _ in
            self.showPicker(type: .photoLibrary)
        }
        let camera = UIAlertAction(title: "拍照", style: .default) { _ in
            self.showPicker(type: .camera)
        }
        alert.addAction(photo)
        alert.addAction(camera)
        
        present(alert, animated: true, completion: nil)

    }
    
    private func showPicker(type: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = type
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    fileprivate func scanImage(image: UIImage) {
        //            "recognize_granularity": "small",
        AipOcrService.shard()?.detectText(from: image, withOptions: nil, successHandler: { (result) in
            guard let r = result as? [String : Any] else {
                self.showError(msg: "error")
                return
            }
            guard let logId = r["log_id"] as? UInt64 else {
                self.showError(msg: "no log id")
                return
            }
            
            guard let result = r["words_result"] as? [[String:Any]] else {
                self.showError(msg: "no word")
                return
            }
            self.handleResult(result: result, logId: "\(logId)")
        }, failHandler: { (error) in
            self.showError(msg: error?.localizedDescription ?? "")
        })
    }
    
    private func handleResult(result: [[String: Any]], logId: String) {
        guard !result.isEmpty else {
            self.showError(msg: "no value")
            return
        }
        let words: [Words] = result.map { (value) -> Words in
            let word = value["words"] as? String
            let location = value["location"] as? [String : UInt32]
            let l = Location(data: location ?? [:])
            return Words(id: logId, words: word ?? "", location: l)
            }.filter { !$0.words.isEmpty}
        drawLines(words: words)
        wordConetxt.insert(words: words.flatMap({
            $0.split()
        }))
        DispatchQueue.main.async {
            self.cd.save()
        }
    }
    
    private func drawLines(words: [Words]) {
        guard let img = scanImage else {
            return
        }
        defer {
            UIGraphicsEndImageContext()
        }
        UIGraphicsBeginImageContext(img.size)
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        ctx.setLineWidth(1.0)
        ctx.setStrokeColor(UIColor.red.cgColor)
        img.draw(in: CGRect(origin: .zero, size: img.size))
        words.forEach { word in
            ctx.addRect(word.location.rect())
        }
        ctx.strokePath()
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        DispatchQueue.main.async {
            self.imageView.image = newImage
            self.imageContainer.isHidden = false
        }
    }
    
    fileprivate func showError(msg: String) {
        let alert = UIAlertController(title: "error", message: msg, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel) { (_) in
            
        }
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordArray.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "work-cell", for: indexPath)
        cell.textLabel?.text = wordArray[indexPath.row].words;
        return cell
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        wordArray = wordConetxt.fetch(word: searchController.searchBar.text ?? "")
        searchResult.reloadData(data: wordArray)
    }
}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer {
            picker.dismiss(animated: true, completion: nil)
        }
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        self.scanImage = image
        self.scanImage(image: image)
        
    }
}

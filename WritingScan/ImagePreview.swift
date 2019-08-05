//
//  ImagePreview.swift
//  WritingScan
//
//  Created by 郑红 on 2019/8/5.
//  Copyright © 2019 com.zhenghong. All rights reserved.
//

import UIKit

class ImagePreview: UIView {
    private var imageView: UIImageView = {
       return UIImageView(frame: .zero)
    }()

    init(image: UIImage?) {
        super.init(frame: .zero)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let top = imageView.topAnchor.constraint(equalTo: topAnchor, constant: 30)
        let left = imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 30)
        let right = imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -30)
        let bottom = imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30)
        NSLayoutConstraint.activate([top, left, bottom, right])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hide))
        addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func show() {
        frame = UIScreen.main.bounds
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    @objc func hide() {
        self.removeFromSuperview()
    }
}

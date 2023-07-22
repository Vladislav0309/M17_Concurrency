//
//  ViewController.swift
//  M17_Concurrency
//
//  Created by Maxim NIkolaev on 08.12.2021.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let dispatchGroup = DispatchGroup()
    let service = Service()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually // надо для картинок прописывать
        
        return stackView
    }()
    
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(stackView)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        onLoad()
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }

    private func onLoad() {
        
        
        for _ in 1...5 {
            
            dispatchGroup.enter()
            
            service.getImageURL { urlString, error in
                guard let urlString = urlString
                else {
                    self.dispatchGroup.leave()
                    return
                }
                
                self.service.loadImage(urlString: urlString) { image in
                    DispatchQueue.main.async {
                        let imageView = UIImageView(image: image)
                        imageView.contentMode = .scaleAspectFit // размер для картинок
                        self.stackView.addArrangedSubview(imageView)
                        
                        self.dispatchGroup.leave()
                    }
                }
            }
        }
            dispatchGroup.notify(queue: DispatchQueue.main) {
                self.activityIndicator.stopAnimating()
            }
        }
    }

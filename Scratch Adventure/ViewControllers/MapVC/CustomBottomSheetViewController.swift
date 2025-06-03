//
//  CustomBottomSheetViewController.swift
//  Scratch Adventure
//
//  Created by USER on 02/05/25.
//

//import UIKit
//
//class CustomBottomSheetViewController: UIViewController {
//    
//     let collapsedHeight: CGFloat = 250
//     let expandedHeight: CGFloat = 500
//    //var isExpanded = false
//        var isExpanded = false {
//            didSet {
//                animateSheet()
//            }
//        }
//    var expendedTableAction: ((Bool) -> Void)?
//    
//     var containerViewTopConstraint: NSLayoutConstraint!
//    private let contentViewController: UIViewController
//    
//    init(contentViewController: UIViewController) {
//     //   self.panGesture = UIPanGestureRecognizer() // 👈 Initialize here
//        self.contentViewController = contentViewController
//        super.init(nibName: nil, bundle: nil)
//        modalPresentationStyle = .overFullScreen
//        modalTransitionStyle = .crossDissolve
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private let backgroundView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
//        return view
//    }()
//    
//    private let containerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .clear
//        view.layer.cornerRadius = 20
//        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        view.clipsToBounds = true
//        return view
//    }()
//    
////    var panGesture: UIPanGestureRecognizer {
////        didSet {
////               panGesture.delegate = self
////            panGesture.isEnabled = isExpanded
////               containerView.addGestureRecognizer(panGesture)
////           }
////   }
//    
//         lazy var panGesture: UIPanGestureRecognizer = {
//            let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
//            pan.delegate = self
//            return pan
//        }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setupViews()
//        setupGestures()
//    
//    embedContentController()
//}
//
//private func setupViews() {
//    view.addSubview(backgroundView)
//    backgroundView.frame = view.bounds
//    
//    view.addSubview(containerView)
//    containerView.translatesAutoresizingMaskIntoConstraints = false
//    
//    containerViewTopConstraint = containerView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -collapsedHeight)
//    
//    NSLayoutConstraint.activate([
//        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//        containerViewTopConstraint,
//        containerView.heightAnchor.constraint(equalToConstant: expandedHeight)
//    ])
//}
//
// func setupGestures() {
//     panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
//    containerView.addGestureRecognizer(panGesture)
//
//    
//    let tapOutside = UITapGestureRecognizer(target: self, action: #selector(dismissSheet))
//    backgroundView.addGestureRecognizer(tapOutside)
//}
//
//private func embedContentController() {
//    addChild(contentViewController)
//    containerView.addSubview(contentViewController.view)
//    contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
//    
//    NSLayoutConstraint.activate([
//        contentViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
//        contentViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
//        contentViewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
//        contentViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
//    ])
//    
//    contentViewController.didMove(toParent: self)
//}
//
//private func animateSheet() {
//    containerViewTopConstraint.constant = isExpanded ? -expandedHeight : -collapsedHeight
//    expendedTableAction?(isExpanded)
//    UIView.animate(withDuration: 0.3) {
//        self.view.layoutIfNeeded()
//    }
//}
//
//@objc private func dismissSheet() {
//    dismiss(animated: true)
//}
//}
//
//// MARK: - UIGestureRecognizerDelegate
//extension CustomBottomSheetViewController: UIGestureRecognizerDelegate {
//    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
//        let translation = gesture.translation(in: view)
//        if gesture.state == .ended {
//            if translation.y < -30 {
//                isExpanded = true
//            } else if translation.y > 30 {
//                isExpanded = false
//            }
//            animateSheet()
//        }
//    }
//    
//}

import UIKit

class CustomBottomSheetViewController: UIViewController {
    
    let collapsedHeight: CGFloat = 250
    let expandedHeight: CGFloat = 500
    var isExpanded = false {
        didSet {
            animateSheet()
        }
    }
    
     var containerViewTopConstraint: NSLayoutConstraint!
    private let contentViewController: UIViewController
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
     lazy var panGesture: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.delegate = self
        return pan
    }()
    
    // MARK: - Init
    init(contentViewController: UIViewController) {
        self.contentViewController = contentViewController
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupGestures()
        embedContentController()
    }

    // MARK: - Setup Views
    private func setupViews() {
        view.addSubview(backgroundView)
        backgroundView.frame = view.bounds
        
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerViewTopConstraint = containerView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -collapsedHeight)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerViewTopConstraint,
            containerView.heightAnchor.constraint(equalToConstant: expandedHeight)
        ])
    }
    
    private func embedContentController() {
        addChild(contentViewController)
        containerView.addSubview(contentViewController.view)
        contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            contentViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            contentViewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            contentViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        contentViewController.didMove(toParent: self)
    }
    
     func setupGestures() {
        containerView.addGestureRecognizer(panGesture)
        
        let tapOutside = UITapGestureRecognizer(target: self, action: #selector(dismissSheet))
        backgroundView.addGestureRecognizer(tapOutside)
    }

    // MARK: - Animate Sheet
    private func animateSheet() {
        containerViewTopConstraint.constant = isExpanded ? -expandedHeight : -collapsedHeight
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - Actions
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)

        if gesture.state == .ended {
            if translation.y < -50 {
                isExpanded = true
            } else if translation.y > 50 {
                isExpanded = false
            }
        }
    }

    @objc private func dismissSheet() {
        dismiss(animated: true)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension CustomBottomSheetViewController: UIGestureRecognizerDelegate {}

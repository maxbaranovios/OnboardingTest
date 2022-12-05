//
//  ViewController.swift
//  OnboardingTest
//
//  Created by Maxim Baranov on 5.12.22.
//

import UIKit

class OnboardingViewController: UIViewController {

    let pageViewController: UIPageViewController
    var pages = [UIViewController]()
    var currentViewController: UIViewController {
        didSet {
            
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                        navigationOrientation: .horizontal)
        
        let pageOne = ViewControllerOne()
        let pageTwo = ViewControllerTwo()
        let pageThree = ViewControllerThree()
        
        pages.append(pageOne)
        pages.append(pageTwo)
        pages.append(pageThree)
        
        currentViewController = pages.first!
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemYellow
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        pageViewController.dataSource = self
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: pageViewController.view.topAnchor),
            view.bottomAnchor.constraint(equalTo: pageViewController.view.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: pageViewController.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: pageViewController.view.trailingAnchor)
        ])
        // ? ? ? setViewController ? ? ?
        pageViewController.setViewControllers([pages.first!],
                                              direction: .forward,
                                              animated: false)
        currentViewController = pages.first!
    }
}

// MARK: - UIPageViewControllerDelegate, UIPageViewControllerDataSource

extension OnboardingViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return getNextViewController(from: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return getPreviousViewController(from: viewController)
    }
    
    private func getPreviousViewController(from viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController),
              index - 1 >= 0 else { return nil }
        currentViewController = pages[index - 1]
        return pages[index - 1]
    }
    
    private func getNextViewController(from viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController),
              index + 1 < pages.count else { return nil }
        currentViewController = pages[index + 1]
        return pages[index + 1]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return pages.firstIndex(of: self.currentViewController) ?? 0
    }
}

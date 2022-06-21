//
//  ViewController.swift
//  collectionViewDemo
//
//  Created by Terry Kuo on 2022/6/10.
//test

import UIKit

struct Group {
    let title: String
    let animals: [String]
}

class ViewController: UIViewController {
    
    let tableOfContentsItems: [TableOfContentsItem] = [
        .symbol(name: "star", isCustom: false),
        .symbol(name: "house", isCustom: false),
        //.symbol(name: "symbol-sloth", isCustom: true)
    ]
    + TableOfContentsSelector.alphanumericItems
    
    
    let tableOfContentsSelector = TableOfContentsSelector()
    
    private let filterButton = FilterFloatingButton(frame: CGRect(x: 250, y: 100, width: 50, height: 50))
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        //        view.translatesAutoresizingaskIntoConstraints = false
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private let dimView: UIView = {
        let uiview = UIView()
        uiview.alpha = 0
        //        uiview.isHidden = true
        uiview.backgroundColor = .black.withAlphaComponent(0.3)
        return uiview
    }()
    
    private let okButton: UIButton = {
        let bt = UIButton(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        bt.setImage(UIImage(systemName: "xmark"), for: .normal)
        bt.tintColor = .black
        bt.layer.cornerRadius = 20
        return bt
    }()
    
    private let animals: [String: [String]] = [
        "A": ["Ant Eater"],
        "B": ["Bear", "Bird"],
        "C": ["Cat"],
        "D": ["Donkey", "Duck", "Dog"],
        "F": ["Fish", "Frog"],
        "G": ["Gorilla", "Gold Fish"],
        "L": ["Lion", ],
        "M": ["Mouse", "Mountain Lion"],
        "P" : ["Panther"],
        "R": ["Rabbit", "Rat"],
        "S": ["Snake"],
        "T": ["Tiger", "Turtle"],
    ]
    
    private let alphabet = "abcdefghijklmnopqrstuvwxyz"
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var models = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        title = "TableView"
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        view.addSubview(tableOfContentsSelector)
        view.addSubview(dimView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableOfContentsSelector.selectionDelegate = self
        tableOfContentsSelector.translatesAutoresizingMaskIntoConstraints = false
        setUpTableOfContentsSelector()
        //tableOfContentsSelector.font = UIFont.systemFont(ofSize: 12.0, weight: .semibold) // Default
        
        configureFilterButton()
        configureContainerView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.size.width, height: view.frame.size.height)
        tableOfContentsSelector.updateWithItems(tableOfContentsItems)
        dimView.frame = view.frame
    }
    
    func setupData() {
        for (key, value) in animals {
            models.append(Group(title: key, animals: value))
        }
        models = models.sorted(by: { $0.title < $1.title })
    }
    
    func test() {
        Task {
            do {
                let images = try await AsyncAwaitPrac.shared.fetchImages()
                print("Fetched: \(images.count) images.")
            } catch {
                print("Fetched error images with \(error.localizedDescription).")
            }
        }
        
    }
    
    func setUpTableOfContentsSelector() {
        NSLayoutConstraint.activate([
            tableOfContentsSelector.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableOfContentsSelector.leadingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: -30),
            tableOfContentsSelector.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableOfContentsSelector.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureFilterButton() {
        view.addSubview(filterButton)
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        filterButton.frame = CGRect(x: view.frame.size.width - 80, y: view.frame.size.height - 100, width: 50, height: 50)
    }
    
    @objc private func filterButtonTapped() {
        UIView.transition(with: containerView, duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
            
            self.containerView.isHidden = false
            self.containerView.frame = CGRect(x: 95, y: 322, width: 200, height: 200)
            
            self.filterButton.frame = CGRect(x: self.view.frame.size.width - 90, y: self.view.frame.size.height - 130, width: 50, height: 50)
            self.filterButton.alpha = 0
            
            self.okButton.isHidden = false
            self.dimView.alpha = 1
            
        })
    }
    
    private func configureContainerView() {
        view.addSubview(containerView)
        
        containerView.addSubview(okButton)
        okButton.convert(containerView.center, from: self.view)
        okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        
        containerView.isHidden = true
        containerView.frame = CGRect(x: view.frame.size.width - 80, y: view.frame.size.height - 100, width: 0, height: 0)
        containerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handler)))
        
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 6
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shouldRasterize = true
        containerView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    @objc private func okButtonTapped() {
        print("OK Tapped..\(self.containerView.frame)")
        print("containerView midx is \(self.containerView.frame.midX)")
        print("containerView midy is \(self.containerView.frame.midY)")
        print("view height is \(self.view.layer.frame.height).")
        print("view width is \(self.view.layer.frame.width).")
        self.okButton.isHidden = true
        UIView.transition(with: self.containerView, duration: 0.3,
                          options: UIView.AnimationOptions.curveEaseOut,
                          animations: {
            
            self.containerView.frame = CGRect(x: self.view.frame.size.width - 80, y: self.view.frame.size.height - 100, width: 0, height: 0)
            //            self.containerView.center = self.view.center
            self.dimView.alpha = 0
            self.filterButton.frame = CGRect(x: self.view.frame.size.width - 80, y: self.view.frame.size.height - 100, width: 50, height: 50)
            self.filterButton.alpha = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.containerView.isHidden = true
                
            }
        })
        
    }
    
    @objc func handler(gesture: UIPanGestureRecognizer){
        let location = gesture.location(in: self.view)
        let draggedView = gesture.view
        draggedView?.center = location
        
        if gesture.state == .ended {
            if self.containerView.frame.midY > self.view.layer.frame.height / 2 {
                self.okButtonTapped()
            } else {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                    //                    self.containerView.center.x = 140
                    self.containerView.frame = CGRect(x: 95, y: 322, width: 200, height: 200)
                }, completion: nil)
            }
        }
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].animals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.section].animals[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return models[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


//MARK: - TableOfContentsSelectionDelegate
extension ViewController: TableOfContentsSelectionDelegate {
    func viewToShowOverlayIn() -> UIView? {
        return self.view
    }
    
    func selectedItem(_ item: TableOfContentsItem) {
        switch item {
        case .letter(let letter):
            let tableindex = self.models.firstIndex(where: { $0.title == letter }) ?? 0
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: NSNotFound, section: tableindex)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        case .symbol(let name, let isCustom):
            print("symbol selected")
        }
        
        
    }
    
    func beganSelection() {
    }
    
    func endedSelection() {
    }
}

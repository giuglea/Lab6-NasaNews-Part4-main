//
//  SearchArticleViewController.swift
//  NasaNews
//
//  Created by Tzy on 25.03.2022.
//

import UIKit

protocol SearchArticleViewType: AnyObject {
    func reloadTable()
    func reloadCollectionView()
}

final class SearchArticleView: UIViewController {
    
    var presenter: SearchArticlePresenter?
    
    @IBOutlet var searchTextField: UITextField?
    
    lazy var stackView = UIStackView
        .vetical(views: collectionView, tableView)
    private let tableView = UITableView()
    private let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePresenter()
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.getAllModels()
        presenter?.getTopModels()
    }
    
    private func configurePresenter() {
        presenter = SearchArticlePresenter()
        presenter?.view = self
    }
    
    @objc
    private func textFieldDidChange() {
        let searchString = searchTextField?.text ?? String()
        presenter?.getAllModels(searchString: searchString)
    }
    private func navigate(item: Item) {
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "ArticleViewController")
                as? ArticleView else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let presenter = ArticlePresenter(managedContext: managedContext)
        presenter.item = item
        presenter.view = viewController
        viewController.presenter = presenter
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
}

// MARK: TableView
extension SearchArticleView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchArticleTableViewCell.cellId, for: indexPath)
                as? SearchArticleTableViewCell else { return UITableViewCell() }
        guard let cellModel = presenter?.getModel(for: indexPath) else { return UITableViewCell() }
        cell.setup(ratingEntity: cellModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getModelsEntities().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let model = presenter?.getModel(for: indexPath) else { return }
        let item = Item(title: model.name ?? String(),
                        date: "",
                        body: model.body ?? String(),
                        itemName: "")
        
        navigate(item: item)
    }
}

// MARK: CollectionView
extension SearchArticleView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.cellId, for: indexPath)
                as? SearchCollectionViewCell else { return UICollectionViewCell() }
        guard let item = presenter?.getTopModel(for: indexPath) else { return UICollectionViewCell() }
        cell.setUp(title: item.name ?? String(), rating: Int(item.rating))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.getTopModelsEntities().count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        presenter?.deleteItemAt(index: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

// MARK: SearchArticleViewType
extension SearchArticleView: SearchArticleViewType {
    func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async { [weak self] in
            if self?.presenter?.getTopModelsEntities().isEmpty ?? true {
                self?.collectionView.isHidden = true
            } else {
                self?.collectionView.isHidden = false
            }
            
            self?.collectionView.reloadData()
        }
    }
}

// MARK: Configure UI
private extension SearchArticleView {
    func configure() {
        setupUI()
        addSubviews()
        addConstrains()
        configureTableView()
        configureCollectionView()
    }
    
    func setupUI() {
        searchTextField?.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    func addSubviews() {
        view.addSubview(stackView)
    }
    
    func addConstrains() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: searchTextField!.bottomAnchor, constant: 10),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.register(SearchArticleTableViewCell.self, forCellReuseIdentifier: SearchArticleTableViewCell.cellId)
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.cellId)
    }
}


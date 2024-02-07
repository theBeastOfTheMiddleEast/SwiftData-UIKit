import UIKit
import SnapKit

final class MainViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        return tableView
    }()
    
    private let viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        viewModel.delegate = self

        view.backgroundColor = .systemBackground
        title = NSLocalizedString("SwiftData with UIKit", comment: "")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: NSLocalizedString("Add", comment: ""),
            style: .plain,
            target: self,
            action: #selector(displayAddItemAlert)
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        viewModel.viewDidFinishLoading()
    }
}

// MARK: - MainViewModelDelegate
extension MainViewController: MainViewModelDelegate {
    func reloadData() {
        tableView.reloadData()
    }
}

// MARK: - Actions
private extension MainViewController {
    @objc func displayAddItemAlert(){
        let controller = UIAlertController(
            title: NSLocalizedString("Info", comment: ""),
            message: NSLocalizedString("Add new item", comment: ""),
            preferredStyle: .alert
        )
        
        controller.addTextField()
        
        controller.addAction(
            UIAlertAction(
                title: NSLocalizedString("Add", comment: ""),
                style: .default) { [weak self] _ in
                    guard let name = controller.textFields?.first?.text else { return }
            
                    self?.viewModel.insertItem(with: name)
                }
        )
        
        present(controller, animated: true, completion: nil)
    }
    
    func displayUpdateAlertForItem(at index: Int) {
        let controller = UIAlertController(
            title: NSLocalizedString("Info", comment: ""),
            message: String(format: NSLocalizedString("Update item: %@", comment: ""), viewModel.items[index].name),
            preferredStyle: .alert
        )
        
        controller.addTextField()
        controller.textFields?.first?.text = viewModel.items[index].name
        
        let action = UIAlertAction(
            title: NSLocalizedString("Update", comment: ""),
            style: .default) { [weak self] _ in
                guard let name = controller.textFields?.first?.text else { return }
            
                self?.viewModel.updateItem(at: index, with: name)
        }
        
        controller.addAction(action)
        
        present(controller, animated: true, completion: nil)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: UITableViewCell.identifier,
            for: indexPath)
        
        cell.textLabel?.text = viewModel.items[indexPath.row].name
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint) -> UIContextMenuConfiguration? {
            return UIContextMenuConfiguration(
                identifier: nil,
                previewProvider: nil,
                actionProvider: { suggestedActions in
                    let deleteAction = UIAction(
                        title: NSLocalizedString("Delete", comment: ""),
                        image: UIImage(systemName: "trash")) { [weak self] _ in
                            self?.viewModel.deleteItem(at: indexPath.row)
                    }
                    
                    let updateAction = UIAction(
                        title: NSLocalizedString("Update", comment: ""),
                        image: UIImage(systemName: "arrow.up.square")) { [weak self] _ in
                            self?.displayUpdateAlertForItem(at: indexPath.row)
                    }
                
                    return UIMenu(
                        title: "",
                        children: [deleteAction, updateAction]
                    )
                }
            )
    }
}

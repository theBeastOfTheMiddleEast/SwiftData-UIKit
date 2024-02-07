import Foundation

protocol MainViewModelDelegate: AnyObject {
    func reloadData()
}

final class MainViewModel {
    weak var delegate: MainViewModelDelegate?
    
    private let databaseManager: LocalDatabaseManager
    
    private(set) var items: [TestModel] = [] {
        didSet {
            delegate?.reloadData()
        }
    }
        
    init(databaseManager: LocalDatabaseManager) {
        self.databaseManager = databaseManager
    }
    
    func viewDidFinishLoading() {
        fetchItems()
    }
    
    func insertItem(with name: String) {
        databaseManager.insert(TestModel(name: name))
        
        fetchItems()
    }
    
    func updateItem(at index: Int, with name: String) {
        guard index < items.count else { return }
        
        items[index].updateName(name)
        
        fetchItems()
    }
    
    func deleteItem(at index: Int) {
        guard index < items.count else { return }
        
        databaseManager.delete(items[index])
        
        fetchItems()
    }
}

private extension MainViewModel {
    func fetchItems() {
        let sortDescriptor = SortDescriptor<TestModel>(\.updatedAt, order: .reverse)
        
        databaseManager.fetchItems(sortDescriptor: sortDescriptor) { [weak self] (result: Result<[TestModel], Error>) in
            switch result {
            case .success(let items):
                self?.items = items
            case .failure(let error):
                print(error)
            }
        }
    }
}

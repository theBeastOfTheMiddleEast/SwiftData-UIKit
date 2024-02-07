import Foundation
import SwiftData

final class LocalDatabaseManager {
    private let context: ModelContext
    
    init?() {
        do {
            let container = try ModelContainer(for: TestModel.self)
            
            context = ModelContext(container)
        } catch {
            print(error)
            return nil
        }
    }
    
    /// Fetches all items of the provided type with a sort descriptor and serves them as sorted by createdAt by default
    func fetchItems<T: BaseModelType>(
        sortDescriptor: SortDescriptor<T> = SortDescriptor<T>(\.createdAt),
        _ completion: (Result<[T], Error>) -> Void) {
            let descriptor = FetchDescriptor<T>(sortBy: [sortDescriptor])
        
            do {
                completion(.success(try context.fetch(descriptor)))
            } catch {
                completion(.failure(error))
            }
    }
    
    /// Inserts item with the provided type
    func insert<T: BaseModelType>(_ model: T) {
        context.insert(model)
    }
    
    /// Deletes item with the provided type
    func delete<T: BaseModelType>(_ model: T) {
        context.delete(model)
    }
    
    /// Deletes all items of the provided type
    func deleteAll<T: BaseModelType>(model: T.Type) {
        do {
            try context.delete(model: T.self)
        } catch {
            print(error)
        }
    }
    
    /// Deletes all items of all models
    func deleteAllData() {
        context.container.deleteAllData()
    }
}

import Foundation
import SwiftData

@Model
class TestModel: BaseModelType {
    @Attribute(.unique) private(set) var id: String
    private(set) var createdAt: Date
    private(set) var updatedAt: Date
    
    var name: String
    
    init(name: String) {
        id = UUID().uuidString
                
        let date = Date()
        createdAt = date
        updatedAt = date
            
        self.name = name
    }
    
    func updateName(_ name: String) {
        self.name = name
        
        updatedAt = Date()
    }
}

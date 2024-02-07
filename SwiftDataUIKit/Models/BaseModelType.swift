import Foundation
import SwiftData

protocol BaseModelType: PersistentModel {
    var id: String { get }
    var createdAt: Date { get }
    var updatedAt: Date { get }
}

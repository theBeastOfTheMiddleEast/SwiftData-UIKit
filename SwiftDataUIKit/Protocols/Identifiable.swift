import Foundation
import UIKit

protocol Identifiable {
    static var identifier: String { get }
}

extension Identifiable {
    static var identifier: String { String(describing: self) }
}

extension UITableViewCell: Identifiable { }

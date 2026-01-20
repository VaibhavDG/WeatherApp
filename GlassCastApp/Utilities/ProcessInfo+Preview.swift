import Foundation

extension ProcessInfo {
    var isPreviewEnvironment: Bool {
        environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}


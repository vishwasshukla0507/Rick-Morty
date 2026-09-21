//___FILEHEADER___

import Kingfisher
import SwiftUI

@main
struct RickNMorty: App {
    
    init() {
        ImageCache.default.memoryStorage.config.totalCostLimit = 100 * 1024 * 1024
        ImageCache.default.diskStorage.config.sizeLimit = 300 * 1024 * 1024
        KingfisherManager.shared.defaultOptions = [.loadDiskFileSynchronously, .backgroundDecode]
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

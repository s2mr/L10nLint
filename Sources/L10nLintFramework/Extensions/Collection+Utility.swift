extension Collection {
    subscript(safe index: Index) -> Element? {
        if indices.contains(index) {
            return self[index]
        }
        return nil
    }
}

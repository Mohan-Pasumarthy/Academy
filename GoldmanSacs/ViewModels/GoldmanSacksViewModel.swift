import Foundation
import Combine

class GoldmanSacksViewModel: ObservableObject {
    @Published var items: [GSItems] = []
    @Published var isLoading: Bool = false

    private let url = "https://api.nasa.gov/planetary/apod?api_key=QYGXmxgECyEEQb27KGb2NNYhGApbpIVsLlbwoFbM&count=15"

    var cancellables = Set<AnyCancellable>()

    init() {
        fetchItems()
    }

    func fetchItems() {
        isLoading = true
        guard let url = URL(string: url) else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> Data in
                guard
                    let response = response as? HTTPURLResponse,
                    response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [GSItems].self, decoder: JSONDecoder())
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    print("COMPLETION: finished")
                case .failure(let error):
                    print("COMPLETION: failure \(error)")
                }
            } receiveValue: { [weak self] returnedItems in
                self?.isLoading = false
                self?.items = returnedItems
                print("Decoded items: \(returnedItems.count)")
            }
            .store(in: &cancellables)
    }
}

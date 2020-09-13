
import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public enum UrlFormatError: Error {
    case emptyUrl
    case noValidHost
}

public final class Lighthouse {
    
    private var tasks: [String: URLSessionTask] = [:]
    
    public init() { }
    
    /// Build Apple App Site Association urls from a given url string.
    public func makeDomainUrl(for urlString: String?) -> Result<[URL], UrlFormatError> {
        guard let urlString = urlString else { 
            return .failure(UrlFormatError.emptyUrl) 
        }
        
        var urlEntry = urlString
        if !urlString.hasPrefix("https://") && !urlString.hasPrefix("http://") {
            urlEntry = "https://" + urlEntry
        }
        
        guard let host = URL(string: urlEntry)?.host else {
            return .failure(UrlFormatError.noValidHost)
        }
        
        var result: [URL?] = []
        
        var newComponents = URLComponents()
        newComponents.host = host
        newComponents.scheme = "https"
        newComponents.path = "/.well-known/apple-app-site-association"
        result.append(newComponents.url)
        
        newComponents.path = "/apple-app-site-association"
        result.append(newComponents.url)
        
        return .success(result.compactMap({ $0 }))
    }
    
    /// Fetch and parser Apple App Site Association content into a reusable structure
    public func getDomainDetails(for url: URL, completion: ((Result<Domain, Error>) -> ())? ) {
        
        fetchDataDomain(for: url) { [weak self] input in
            guard let `self` = self else {                
                return
            }
            
            completion?(self.parserDomainCompletion(input))
        }
    }
    
    // MARK: - Parser
    
    private func parserDomainCompletion(_ input: Result<Data, Error>) -> Result<Domain, Error> {
        switch input {
        case .failure(let error):
            return .failure(error)
        case .success(let data):
            do {
                let decoder = JSONDecoder()
                let domain = try decoder.decode(Domain.self, from: data)
                return .success(domain)
            } catch {
                return .failure(error)
            }
        }
    }
    
    // MARK: - Network Request
    
    private func fetchDataDomain(for url: URL, completion: @escaping ((Result<Data, Error>) -> ())) {
        
        if let knownTask = tasks[url.absoluteString] {
            knownTask.cancel()
        } 
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                completion(.success(data))
            }
            
            self?.tasks.removeValue(forKey: url.absoluteString)
        }
        
        tasks[url.absoluteString] = task
        task.resume()
    }
}

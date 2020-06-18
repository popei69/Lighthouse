import XCTest
@testable import lighthouse

final class LighthouseTests: XCTestCase {
    
    var lighthouse: Lighthouse!
    
    override func setUp() {
        lighthouse = Lighthouse()
    }
    
    func test_empty_value() {
        let result = lighthouse.makeDomainUrl(for: nil)
        switch result {
        case .success:
            XCTFail("Expecting error")
        case .failure(let error):
            XCTAssert(error == UrlFormatError.emptyUrl)
        }
    }
    
    func test_empty_string_value() {
        let result = lighthouse.makeDomainUrl(for: "")
        switch result {
        case .success:
            XCTFail("Expecting error")
        case .failure(let error):
            XCTAssert(error == UrlFormatError.noValidHost)
        }
    }
    
    func test_url_non_http() {
        let result = lighthouse.makeDomainUrl(for: "http://google.com")
        switch result {
        case .failure:
            XCTFail("Expecting valid result")
        case .success(let urls):
            XCTAssertEqual(urls.count, 2)
            XCTAssertFalse(urls.contains(where:{ $0.absoluteString.hasPrefix("http://") }))
        }
    }
    
    func test_url_all_https() {
        let result = lighthouse.makeDomainUrl(for: "google.com")
        switch result {
        case .failure:
            XCTFail("Expecting valid result")
        case .success(let urls):
            XCTAssertEqual(urls.count, 2)
            XCTAssertFalse(urls.contains(where:{ !$0.absoluteString.hasPrefix("https://") }))
        }
    }
    
    func test_url_file_matching() {
        let result = lighthouse.makeDomainUrl(for: "google.com")
        switch result {
        case .failure:
            XCTFail("Expecting valid result")
        case .success(let urls):
            XCTAssertFalse(urls.contains(where:{ !$0.absoluteString.hasSuffix("apple-app-site-association") }))
        }
    }

    static var allTests = [
        ("test_empty_value", test_empty_value),
        ("test_url_non_http", test_url_non_http),
    ]
}

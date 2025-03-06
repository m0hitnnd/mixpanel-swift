import XCTest
import zlib
@testable import Mixpanel

class MixpanelGzipTests: MixpanelBaseTests {
    
    func testGzipNotSameAsOriginal() {
        let originalString = String.randomString(length: 100)
        guard let originalData = originalString.data(using: .utf8) else {
            XCTFail("Failed to create data from string")
            return
        }
        
        guard let ourGzippedData = originalData.gzipped() else {
            XCTFail( "Gzipped data from wrapper should not be nil")
            return
        }
        XCTAssertNotEqual(
            ourGzippedData,
            originalData,
            "Gzipped data should not be equal to original data"
        )
    }
    
    func testGzipEmptyData() {
        let emptyData = Data()
        let compressed = emptyData.gzipped()
        XCTAssertNil(compressed, "Empty data should result in nil gzip output")
    }
    
    func testGzipIntegrationForInstance() {
        // Test Mixpanel integration
        let testMixpanel = Mixpanel.initialize(token: randomId(), trackAutomaticEvents: true, flushInterval: 60)
        XCTAssertFalse(testMixpanel.useGzipCompression, "GZIP compression should be disabled by default")
        
        testMixpanel.useGzipCompression = true
        XCTAssertTrue(testMixpanel.useGzipCompression, "GZIP compression should be enabled after setting")
        
        // Verify the setting is passed through to FlushRequest
        XCTAssertTrue(testMixpanel.flushInstance.useGzipCompression, "GZIP compression setting should be passed to flush instance")
    }
}

private extension String {
    
    /// Generate random letters string for test.
    static func randomString(length: Int) -> String {
        
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 "
        let characters = (0..<length).map { _ in letters.randomElement()! }
        
        return String(characters)
    }
}


import XCTest
@testable import Mixpanel

class MixpanelGzipTests: XCTestCase {

    func testGzipCompression() {
        // Test data compression
        let testData = String(repeating: "Test data for compression ", count: 100).data(using: .utf8)!
        let compressedData = testData.gzipped()

        XCTAssertNotNil(compressedData, "Data compression should succeed")
        XCTAssertLessThan(compressedData!.count, testData.count, "Compressed data should be smaller than original")

        // Test Mixpanel integration
        let testMixpanel = Mixpanel.initialize(token: randomId(), trackAutomaticEvents: true, flushInterval: 60)
        XCTAssertFalse(testMixpanel.useGzipCompression, "GZIP compression should be disabled by default")

        testMixpanel.useGzipCompression = true
        XCTAssertTrue(testMixpanel.useGzipCompression, "GZIP compression should be enabled after setting")

        // Verify the setting is passed through to FlushRequest
        XCTAssertTrue(testMixpanel.flushInstance.useGzipCompression, "GZIP compression setting should be passed to flush instance")
    }

    private func randomId() -> String {
        return String(format: "%08x%08x", arc4random(), arc4random())
    }
}

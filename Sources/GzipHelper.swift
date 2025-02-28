import Foundation
import zlib

extension Data {
    func gzipped() -> Data? {
        guard !isEmpty else { return nil }

        var stream = z_stream()
        stream.zalloc = nil
        stream.zfree = nil
        stream.opaque = nil

        guard deflateInit2_(&stream, Z_DEFAULT_COMPRESSION, Z_DEFLATED, 31, 8, Z_DEFAULT_STRATEGY, ZLIB_VERSION, Int32(MemoryLayout<z_stream>.size)) == Z_OK else {
            return nil
        }

        var data = Data(capacity: count)
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 1024)
        defer {
            buffer.deallocate()
            deflateEnd(&stream)
        }

        stream.avail_in = UInt32(count)
        self.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
            stream.next_in = UnsafeMutablePointer<UInt8>(mutating: bytes.bindMemory(to: UInt8.self).baseAddress!)
        }

        repeat {
            stream.avail_out = 1024
            stream.next_out = buffer
            let status = deflate(&stream, Z_FINISH)

            guard status != Z_STREAM_ERROR else { return nil }

            let bytesProcessed = 1024 - Int(stream.avail_out)
            data.append(buffer, count: bytesProcessed)

        } while stream.avail_out == 0

        return data
    }
}

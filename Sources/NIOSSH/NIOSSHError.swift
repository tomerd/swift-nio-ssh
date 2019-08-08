//===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftNIO open source project
//
// Copyright (c) 2019 Apple Inc. and the SwiftNIO project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftNIO project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//


/// An error thrown by NIOSSH.
///
/// For extensibility purposes, `NIOSSHError`s are composed of two parts. The first part is an
/// error type. This is like an enum, but extensible, and identifies the kind of error programmatically.
/// The second part is some opaque diagnostic data. This is not visible to your code, but is used to
/// help provide extra information for diagnostic purposes when logging this error.
///
/// Note that due to this construction `NIOSSHError` is not equatable: only the `type` is. This is deliberate,
/// as it is possible two errors have the same type but a different underlying cause or diagnostic data. For
/// this reason, if you need to compare two `NIOSSHError` values you should explicitly compare their `type`.
public struct NIOSSHError: Error {
    public var type: ErrorType

    private var diagnostics: String
}


// MARK:- Internal helper functions for error construction.
extension NIOSSHError {
    internal static func invalidSSHMessage(reason: String) -> NIOSSHError {
        return NIOSSHError(type: .invalidSSHMessage, diagnostics: reason)
    }

    internal static func weakSharedSecret(exchangeAlgorithm: String) -> NIOSSHError {
        return NIOSSHError(type: .weakSharedSecret, diagnostics: exchangeAlgorithm)
    }

    internal static let invalidNonceLength = NIOSSHError(type: .invalidNonceLength, diagnostics: "")

    internal static let invalidEncryptedPacketLength = NIOSSHError(type: .invalidEncryptedPacketLength, diagnostics: "")

    internal static let invalidDecryptedPlaintextLength = NIOSSHError(type: .invalidDecryptedPlaintextLength, diagnostics: "")

    internal static let invalidKeySize = NIOSSHError(type: .invalidKeySize, diagnostics: "")

    internal static let insufficientPadding = NIOSSHError(type: .insufficientPadding, diagnostics: "")

    internal static let excessPadding = NIOSSHError(type: .excessPadding, diagnostics: "")
}


// MARK:- NIOSSHError CustomStringConvertible conformance.
extension NIOSSHError: CustomStringConvertible {
    public var description: String {
        return "NIOSSHError.\(self.type.description): \(self.diagnostics)"
    }
}


// MARK:- Definition of NIOSSHError.ErrorType
extension NIOSSHError {
    /// The types of NIOSSHError that can be encountered.
    public struct ErrorType {
        private enum Base: Hashable {
            case invalidSSHMessage
            case weakSharedSecret
            case invalidNonceLength
            case invalidEncryptedPacketLength
            case invalidDecryptedPlaintextLength
            case invalidKeySize
            case insufficientPadding
            case excessPadding
        }

        private var base: Base

        private init(_ base: Base) {
            self.base = base
        }

        /// An invalid SSH message was received.
        public static let invalidSSHMessage: ErrorType = .init(.invalidSSHMessage)

        /// The key exchange process generated a weak shared secret.
        public static let weakSharedSecret: ErrorType = .init(.weakSharedSecret)

        /// The length of the nonce provided to a cipher is invalid for that cipher.
        public static let invalidNonceLength: ErrorType = .init(.invalidNonceLength)

        /// The encrypted packet received has an invalid length for the negotiated encyption scheme
        public static let invalidEncryptedPacketLength: ErrorType = .init(.invalidEncryptedPacketLength)

        /// The decrypted plaintext length is not a multiple of the block size.
        public static let invalidDecryptedPlaintextLength: ErrorType = .init(.invalidDecryptedPlaintextLength)

        /// The generated key size was invalid for the given encryption scheme.
        public static let invalidKeySize: ErrorType = .init(.invalidKeySize)

        /// A packet was decrypted that had insufficient padding.
        public static let insufficientPadding: ErrorType = .init(.insufficientPadding)

        /// More padding bytes were supposed to be present than actually are present in a packet.
        public static let excessPadding: ErrorType = .init(.excessPadding)
    }
}


// MARK:- NIOSSHError.ErrorType Hashable conformance
extension NIOSSHError.ErrorType: Hashable { }


// MARK:- NIOSSHError.ErrorType CustomStringConvertible conformance
extension NIOSSHError.ErrorType: CustomStringConvertible {
    public var description: String {
        return String(describing: self.base)
    }
}

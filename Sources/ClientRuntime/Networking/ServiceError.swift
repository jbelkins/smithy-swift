/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0.
 */

import Foundation

public protocol ServiceError {
    var _retryable: Bool { get set }
    var _isThrottling: Bool { get set}
    var _type: ErrorType { get set }
    var _message: String? { get set }

    /// The name (without namespace) of the model this error is based upon.
    /// For an unknown error, this is an empty string.
    static var _modelName: String { get }
}

public enum ErrorType: Equatable {
    case server
    case client
    case unknown
}

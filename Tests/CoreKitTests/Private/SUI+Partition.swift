//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import MainIntKit
import TestKit

//*============================================================================*
// MARK: * Strict Unsigned Integer x Partition x Sub Sequence
//*============================================================================*

final class StrictUnsignedIntegerSubSequenceTestsOnPartition: XCTestCase {
    
    typealias X   = [UX]
    typealias X64 = [U64]
    typealias X32 = [U32]

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testPartitionNoRedundantZeros() {
        checkPartitionNoRedundantZeros([          ] as X, 0 as Int, [          ] as X, [          ] as X)
        checkPartitionNoRedundantZeros([          ] as X, 1 as Int, [          ] as X, [          ] as X)
        checkPartitionNoRedundantZeros([          ] as X, 2 as Int, [          ] as X, [          ] as X)
        checkPartitionNoRedundantZeros([          ] as X, 3 as Int, [          ] as X, [          ] as X)
        checkPartitionNoRedundantZeros([1         ] as X, 0 as Int, [          ] as X, [1         ] as X)
        checkPartitionNoRedundantZeros([1         ] as X, 1 as Int, [1         ] as X, [          ] as X)
        checkPartitionNoRedundantZeros([1         ] as X, 2 as Int, [1         ] as X, [          ] as X)
        checkPartitionNoRedundantZeros([1         ] as X, 3 as Int, [1         ] as X, [          ] as X)
        checkPartitionNoRedundantZeros([1, 2      ] as X, 0 as Int, [          ] as X, [1, 2      ] as X)
        checkPartitionNoRedundantZeros([1, 2      ] as X, 1 as Int, [1         ] as X, [   2      ] as X)
        checkPartitionNoRedundantZeros([1, 2      ] as X, 2 as Int, [1, 2      ] as X, [          ] as X)
        checkPartitionNoRedundantZeros([1, 2      ] as X, 3 as Int, [1, 2      ] as X, [          ] as X)
        checkPartitionNoRedundantZeros([1, 2, 3   ] as X, 0 as Int, [          ] as X, [1, 2, 3   ] as X)
        checkPartitionNoRedundantZeros([1, 2, 3   ] as X, 1 as Int, [1         ] as X, [   2, 3   ] as X)
        checkPartitionNoRedundantZeros([1, 2, 3   ] as X, 2 as Int, [1, 2      ] as X, [      3   ] as X)
        checkPartitionNoRedundantZeros([1, 2, 3   ] as X, 3 as Int, [1, 2, 3   ] as X, [          ] as X)
        checkPartitionNoRedundantZeros([1, 2, 3, 4] as X, 0 as Int, [          ] as X, [1, 2, 3, 4] as X)
        checkPartitionNoRedundantZeros([1, 2, 3, 4] as X, 1 as Int, [1         ] as X, [   2, 3, 4] as X)
        checkPartitionNoRedundantZeros([1, 2, 3, 4] as X, 2 as Int, [1, 2      ] as X, [      3, 4] as X)
        checkPartitionNoRedundantZeros([1, 2, 3, 4] as X, 3 as Int, [1, 2, 3   ] as X, [         4] as X)
        checkPartitionNoRedundantZeros([0, 0, 0, 0] as X, 0 as Int, [          ] as X, [          ] as X)
        checkPartitionNoRedundantZeros([0, 0, 0, 0] as X, 1 as Int, [          ] as X, [          ] as X)
        checkPartitionNoRedundantZeros([0, 0, 0, 0] as X, 2 as Int, [          ] as X, [          ] as X)
        checkPartitionNoRedundantZeros([0, 0, 0, 0] as X, 3 as Int, [          ] as X, [          ] as X)
        checkPartitionNoRedundantZeros([1, 0, 3, 0] as X, 0 as Int, [          ] as X, [1, 0, 3   ] as X)
        checkPartitionNoRedundantZeros([1, 0, 3, 0] as X, 1 as Int, [1         ] as X, [   0, 3   ] as X)
        checkPartitionNoRedundantZeros([1, 0, 3, 0] as X, 2 as Int, [1         ] as X, [      3   ] as X)
        checkPartitionNoRedundantZeros([1, 0, 3, 0] as X, 3 as Int, [1, 0, 3   ] as X, [          ] as X)
        checkPartitionNoRedundantZeros([0, 2, 0, 4] as X, 0 as Int, [          ] as X, [0, 2, 0, 4] as X)
        checkPartitionNoRedundantZeros([0, 2, 0, 4] as X, 1 as Int, [          ] as X, [   2, 0, 4] as X)
        checkPartitionNoRedundantZeros([0, 2, 0, 4] as X, 2 as Int, [0, 2      ] as X, [      0, 4] as X)
        checkPartitionNoRedundantZeros([0, 2, 0, 4] as X, 3 as Int, [0, 2      ] as X, [         4] as X)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    private func checkPartitionNoRedundantZeros(
    _ base: [UX], _ index: Int, _ low: [UX], _ high: [UX],
    file: StaticString = #file, line: UInt = #line) {
        //=------------------------------------------=
        base.withUnsafeBufferPointer { base in
            let partition = SUISS.partitionNoRedundantZeros(base, at: index)
            
            XCTAssertEqual([UX](partition.low ),  low,  file: file, line: line)
            XCTAssertEqual([UX](partition.high),  high, file: file, line: line)
            
            XCTAssertNotEqual(partition.low .last, 000, file: file, line: line)
            XCTAssertNotEqual(partition.high.last, 000, file: file, line: line)
        }
    }
}

//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Global x Info
//*============================================================================*

#if DEBUG
public let isDebug:   Bool = true
public let isRelease: Bool = false
#else
public let isDebug:   Bool = false
public let isRelease: Bool = true
#endif

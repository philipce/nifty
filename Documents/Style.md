# Style Guide

This document lays out the general conventions and standards for Nifty. 

*Contributions should endeavor to adhere to this style guide and remain consistent with the existing body of code. However, the real goal is to make code as clear as possible so we fully expect that some exceptions will arise. We also expect this style guide to evolve, so suggestions and improvements to this document are encouraged.*

##### Organization

- One piece of functionality per file. This usually means that a file defines a single public function.
- Overloads for a function ought to be part of the same file as the function being overloaded.
- All internal and/or private functionality should be contained in the same file as the public functionality.
- Internal functionality should only be stuck in a file with a public function if it is obviously most closely tied to that function--if multiple files use the internal functionality (which should be the case, otherwise it ought to be fileprivate) and it isn't clear which file is most closely related, the internal functionality ought to be promoted to its own file.
- Limit visibility as much as possible! This means most helper functions/data in a file ought to be marked `fileprivate`; use `internal` only when it's clear some other file needs to use it.
- We favor a functional style over a more object-oriented organization, e.g. `inv(A)` computes the inverse of matrix A rather than `A.inv()`

#### Naming

- Files should be named for the public function it contains, e.g. max.swift contains 
the `max` function (plus public overloads, internal and private stuff).
- Since we are following MATLAB naming, function names should match any corresponding MATLAB function names.
- Functions that don't have a MATLAB counterpart should be named something that feels consistent with MATLAB's naming style.
- Parameters do not need to be named for what is in the MATLAB documentation.
- Most functions should have all parameters named; the exception might be for the first one or two parameters in functions where it's obvious what they do.

##### Code

- Lines should end at 100 characters, but it's flexible if your line is close.
- Avoid overcommenting code--make code as self-documenting as possible, adding comments only when an needed to explain the motivation, a tricky bit, etc.
- Prefer putting comments above a line of code rather than at the end.
- Avoid /* */ comments in favor of commenting each line.

##### Function Headers

Every public function must have a header comment. Internal and private functions may ommit the header if the usage is obvious. Use the following comment block:

```
/// Brief (one or 2 sentences) description of function, e.g. Compute the 
/// magnitude of a vector in three dimensions from the given components.
///
/// More details, notes, explanation, caution, etc. Multi paragraph okay.
///
/// The above components should be complete sentences with proper punctuation.
///
/// - Parameters:
///     - x: the x component of the vector (no need to be a complete sentence)
///     - y: the y component of the vector 
///     - z: the z component of the vector 
/// - Throws: if some type of error occurs (no need to enumerate specific errors)
/// - Returns: computed vector magnitude
```

##### File Header

Every file ought to have a header that indicates purpose, original author,
original creation date, contributors, license, and, copyright. 

```
/*******************************************************************************
 *  fileName.swift
 *
 *  [This file provides... ONE complete sentence description of file.]
 *
 *  Author: [Bob the Original Author]
 *  Creation Date: [1 Jan 1970, in this format... NOT last modified date]
 *  Contributors: [add name here if you contributed substantially to this file]
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *  Copyright [yyyy] [name of copyright owner]
 ******************************************************************************/
```
## 0.2.0

- Fixed issue when trying to parse only a '+' or '-' throwing a RangeError instead of a FormatException
- Updated packages

## 0.1.1

- Fixed rounding error in toIso8601String(). For example 16.992s resulted in string "PT16.10S" (only 1 fraction
  digit is allowd). 

## 0.1.0

- Initial version.

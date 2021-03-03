(import (chicken platform)
        (only (rename (chicken random) (pseudo-random-integer random-integer))
              random-integer)
        r7rs)

(register-feature! 'srfi-132)

(include "sorting/132.sld")

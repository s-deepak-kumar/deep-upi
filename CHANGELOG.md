## 0.0.1

* TODO: Describe initial release.

## 0.0.4

* Rename package to `deep_upi` and method channel to `deep_upi`.
* Gate merchant parameters (`mc`, `tid`, `tr`, `url`, `sign`) on non-empty `merchantCode`.
* Default to P2P flow when `merchantCode` is empty or null.
* Update example and README to P2P-first usage.
* iOS: add `deep_upi.podspec` and remove old podspec.

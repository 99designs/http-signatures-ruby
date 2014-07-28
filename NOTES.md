# HTTP Signatures: notes


## Concepts

* Algorithm
    * Algorithm name
    * Algorithm implementation
    * Algorithm map `map[name] = algorithm`
* Key
    * Key ID
    * Key secret
    * Key map `map[id] = secret`
* HTTP message
    * HTTP request or HTTP response
    * Header
    * Body
* Signature
    * Signature header line
    * Signature parameters
        * `keyId`
        * `algorithm`
        * `headers`
        * `signature` `base64(signature(key_secret, signing_string))`
* Signing string
* Normalization
    * `request-target` e.g. `get /some/path?some=query`
    * Header names (lower-case)
    * Duplicate headers (concatenate, preserve order)
    * Ordering (as specified in signature parameters)
* Verifier
    * Signature header line parser
* Signer


## Questions

* `Signature` header vs. `Authorization` header?
    * The 'Signature' HTTP Authentication Scheme
    * The 'Signature' HTTP Header


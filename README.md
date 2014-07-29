# HTTP Signatures

Ruby implementation of [HTTP Signatures][draft03] draft specification;
cryptographically sign and verify HTTP requests and responses.


## Usage

Configure a context with your algorithm, keys, headers to sign. In Rails,
this is best placed in an initializer.

```rb
require "http_signatures"

$context = HttpSignatures::Context.new(
  keys: {"examplekey" => "secret-key-here"},
  algorithm: "hmac-sha256",
  headers: %w{(request-target) Date Content-Length},
)
```

### Messages

A message is an HTTP request or response. A subset of the interface of
Ruby's Net::HTTPRequest and Net::HTTPResponse is expected; the ability to
set/read headers via `message["name"]`, and for requests, the presence
of `message#method` and `message#path` for `(request-target)` support.

```rb
require "net/http"
require "time"
message = Net::HTTP::Get.new(
  "/path?query=123",
  "Date" => Time.now.rfc822,
  "Content-Length" => "0",
)
```

### Signing a message

```rb
$context.signer("examplekey").sign(message)
```

Now `message` contains the signature headers:

```rb
message["Signature"]
# keyId="examplekey",algorithm="hmac-sha256",headers="...",signature="..."

message["Authorization"]
# Signature keyId="examplekey",algorithm="hmac-sha256",headers="...",signature="..."
```

### Verifying a signed message

Message verification is not implemented, but will look like this:

* The key ID, algorithm name, header list and provided signature will be parsed
  from the `Signature` and/or `Authorization` header.
* The signing string will be derived by selecting the listed headers from the
  message.
* The valid signature will be derived by applying the algorithm and secret key.
* The message is valid if the provided signature matches the valid signature.


## Contributing

Pull Requests are welcome.


[draft03]: http://tools.ietf.org/html/draft-cavage-http-signatures-03

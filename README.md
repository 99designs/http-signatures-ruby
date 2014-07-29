# HTTP Signatures

Ruby implementation of [HTTP Signatures][draft03] draft specification;
cryptographically sign and verify HTTP requests and responses.


## Usage

Configure a context with your algorithm, keys, headers to sign. In Rails,
this is best placed in an initializer.

```rb
$context = HttpSignatures::Context.new(
  keys: {"examplekey" => "secret-key-here"},
  algorithm: "hmac-sha256",
  headers: %w{(request-target) date content-length},
)
```

### Signing a message

`message` is an `HttpSignatures::Message` instance, representing an HTTP
request or response. Adapters for Ruby's `Net::HTTP` and other HTTP clients
will be forthcoming.

```rb
signed_message = $context.signer("examplekey").sign(message)
```

Now `signed_message` contains the signature headers:

```rb
signed_message.header["Signature"]
# keyId="examplekey",algorithm="hmac-sha256",headers="...",signature="..."

signed_message.header["Authorization"]
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

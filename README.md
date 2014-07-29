# HTTP Signatures

Ruby implementation of [HTTP Signatures][draft03] draft specification.

Cryptographically sign and verify HTTP messages.


## Usage

Configure a context with your algorithm, keys, headers to sign. In Rails,
this is best placed in an initializer.

```rb
$context = HttpSignatures::Context.new(
  keys: {"keyname" => "secret-key-here"},
  algorithm: "hmac-sha256",
  headers: %w{(request-target) date content-length},
)
```

Sign a message. `message` is an `HttpSignatures::Message` instance,
representing an HTTP request or response. Adapters for Ruby's `Net::HTTP` and
other HTTP clients will be forthcoming.

```rb
signed_message = $context.signer("keyname").sign(message)
```

Now `signed_message` contains the signature headers:

```rb
signed_message.header["Signature"]
# => keyId="keyname",algorithm="hmac-sha256",headers="...",signature="..."

signed_message.header["Authorization"]
# => Signature keyId="keyname",algorithm="hmac-sha256",headers="...",signature="..."
```


## Contributing

Pull Requests are welcome.


[draft03]: http://tools.ietf.org/html/draft-cavage-http-signatures-03

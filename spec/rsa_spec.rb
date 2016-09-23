# NOTE: All test data in this spec are same as
# https://github.com/tomitribe/http-signatures-java/blob/master/src/test/java/org/tomitribe/auth/signatures/RsaTest.java

RSpec.shared_examples_for "signer" do |expected_signature|
  let(:provided_signature) { HttpSignatures::SignatureParametersParser.new(message["signature"]).parse.fetch("signature") }
  it "returns expected signature" do
    context.signer.sign message
    expect(provided_signature).to eq(expected_signature)
  end
end

RSpec.shared_examples_for "verifier" do
  it "validates signature" do
    context.signer.sign message
    expect(context.verifier.valid? message).to eq(true)
  end
end

RSpec.describe "Using RSA" do
  let(:public_key) { File.read(File.join(__dir__, "keys", "id_rsa.pub")) }
  let(:private_key) { File.read(File.join(__dir__, "keys", "id_rsa")) }

  let(:message) do
    Net::HTTP::Post.new(
      "/foo?param=value&pet=dog",
      "Host" => "example.org",
      "Date" => "Thu, 05 Jan 2012 21:31:40 GMT",
      "Content-Type" => "application/json",
      "Digest" => "SHA-256=X48E9qOokqqrvdts8nOJRJN3OWDUoyWxBf7kbu9DBPE=",
      "Accept" => "*/*",
      "Content-Length" => "18"
    )
  end

  let(:context) do
    HttpSignatures::Context.new(
      keys: {
        "my_rsa_key_pair" => {
          private_key: private_key,
          public_key: public_key,
        },
      },
      signing_key_id: "my_rsa_key_pair",
      algorithm: algorithm,
      headers: headers,
    )
  end

  describe "context.signer.sign and context.verifier.valid?" do
    context "algorithm is rsa-sha1" do
      let(:algorithm) { "rsa-sha1" }

      context "headers are %w{date}" do
        let(:headers) { %w{date} }
        it_behaves_like "signer", "kcX/cWMRQEjUPfF6AO7ANZ/eQkpRd" +
          "/4+dr3g1B5HZBn3vRDxGFbDRY19HeJUUlBAgmvolRwLlrVkz" +
          "LOmYdug6Ff01UUl6gX+TksGbsxagbNUNoEx0hrX3+8Jbd+x8" +
          "gx9gZxA7DwXww1u3bGrmChnfkdOofY52KhUllUox4mmBeI="
        it_behaves_like "verifier"
      end

      context "headers are %w{(request-target) host date}" do
        let(:headers) { %w{(request-target) host date} }
        it_behaves_like "signer", "F6g4qdBSHBcWo1iMsHetQU9TnPF39" +
          "naVHQogAhgvY6wh0/cdkquN4D6CInTyEHtMuv7xlOt0yBaVt" +
          "brrNP5JZKquYMW2JC3FXdtIiaYWhLUb/Nmb+JPr6C8AnxMzc" +
          "fNfuOZFn3X7ekA32qbfnYr7loHqpEGUr+G1NYsckEXdlM4="
        it_behaves_like "verifier"
      end
    end

    context "algorithm is sha256" do
      let(:algorithm) { "rsa-sha256" }

      context "headers are %w{date}" do
        let(:headers) { %w{date} }
        it_behaves_like "signer", "ATp0r26dbMIxOopqw0OfABDT7CKMI" +
          "oENumuruOtarj8n/97Q3htHFYpH8yOSQk3Z5zh8UxUym6FYT" +
          "b5+A0Nz3NRsXJibnYi7brE/4tx5But9kkFGzG+xpUmimN4c3" +
          "TMN7OFH//+r8hBf7BT9/GmHDUVZT2JzWGLZES2xDOUuMtA="
        it_behaves_like "verifier"
      end

      context "headers are %w{(request-target) host date}" do
        let(:headers) { %w{(request-target) host date} }
        it_behaves_like "signer", "DT9vcDFbit2ahGZowjUzzih+sVpKM" +
          "IPZrXy1DMljImYNSJ3UEweTMfF3MUFjdNwYH59IDJoB+QTg3" +
          "Rpm5xLvMWD7tql/Ng/NCJs8gYSNjOQidArEpWp88c5IQPDXn" +
          "1lnJMU6dNXZNxc8Yqj+mIYhwHpKEKTqnvEtnCvB/6y/dIM="
        it_behaves_like "verifier"
      end
    end

    context "algorithm is sha384" do
      let(:algorithm) { "rsa-sha384" }

      context "headers are %w{date}" do
        let(:headers) { %w{date} }
        it_behaves_like "signer", "AYtR6NQy+59Ta3X1GYNlfOzJo4Sg+" +
          "aB+ulDkR6Q2/8egvByRx5l0+t/2abAaFHf33SDojHYWPlpuj" +
          "HM26ExZPFXeYzG9sRctKD7XKrA/F6LRXEm1RXLFvfvLXQw4P" +
          "4HE1PMH+gCw2E+6IoTnbcimQtZ82SkF1uDRtLDhR6iqpFI="
        it_behaves_like "verifier"
      end

      context "headers are %w{(request-target) host date}" do
        let(:headers) { %w{(request-target) host date} }
        it_behaves_like "signer", "mRaP0Z5lh9XKGDahdsomoKR9Kjsj9" +
          "a/lgUEpZDQpvSZq5NhODEjmQh1qRn6Sx/c+AFl67yzDYAMXx" +
          "9h49ZOpKpuj4FGrz5/DIK7cdn9wXBKqDYgDfwOF9O5jNOE1r" +
          "9zbORTH0XxA8WE9H/MXoOrDIH1NjM5o9I4ErT4zKnD5OsQ="
        it_behaves_like "verifier"
      end
    end

    context "algorithm is sha512" do
      let(:algorithm) { "rsa-sha512" }

      context "headers are %w{date}" do
        let(:headers) { %w{date} }
        it_behaves_like "signer", "IItboA8OJgL8WSAnJa8MND04s9j7d" +
          "B6IJIBVpOGJph8Tmkc5yUAYjvO/UQUKytRBe5CSv2GLfTAmE" +
          "7SuRgGGMwdQZubNJqRCiVPKBpuA47lXrKgC/wB0QAMkPHI6c" +
          "PllBZRixmjZuU9mIbuLjXMHR+v/DZwOHT9k8x0ILUq2rKE="
        it_behaves_like "verifier"
      end

      context "headers are %w{(request-target) host date}" do
        let(:headers) { %w{(request-target) host date} }
        it_behaves_like "signer", "ggIa4bcI7q377gNoQ7qVYxTA4pEOl" +
          "xlFzRtiQV0SdPam4sK58SFO9EtzE0P1zVTymTnsSRChmFU2p" +
          "n+R9VzkAhQ+yEbTqzu+mgHc4P1L5IeeXQ5aAmGENfkRbm2vd" +
          "OZzP5j6ruB+SJXIlhnaum2lsuyytSS0m/GkWvFJVZFu33M="
        it_behaves_like "verifier"
      end
    end
  end
end

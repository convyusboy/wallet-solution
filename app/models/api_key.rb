class ApiKey < ApplicationRecord
  HMAC_SECRET_KEY = "46423c4ca0daad33706b94ddb2b0398dac1c7fdd81141578e0a6b86d22ab91b5"

  belongs_to :bearer, polymorphic: true

  before_create :generate_token_hmac_digest

  attr_accessor :token

  def self.authenticate_by_token!(token)
    digest = OpenSSL::HMAC.hexdigest "SHA256", HMAC_SECRET_KEY, token

    find_by! token_digest: digest
  end

  def self.authenticate_by_token(token)
    authenticate_by_token! token
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def serializable_hash(options = nil)
    h = super options.merge(except: "token_digest") if options.present?
    h.merge! "token" => token if token.present?
    h
  end

  private

  def generate_token_hmac_digest
    raise ActiveRecord::RecordInvalid, "token is required" unless token.present?

    digest = OpenSSL::HMAC.hexdigest "SHA256", HMAC_SECRET_KEY, token

    self.token_digest = digest
  end
end

# This serializer is based on Nando Vieira's blog post on JSONB in Rails:
# http://nandovieira.com/using-postgresql-and-jsonb-with-ruby-on-rails
class HashSerializer

  class << self

    def dump(hash)
      hash.to_json
    end

    def load(hash)
      (hash || {}).with_indifferent_access
    end

  end

end
module ContentfulRenderable
  extend ActiveSupport::Concern

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def client
      @client ||= Contentful::Client.new(
        access_token: ENV['CONTENTFUL_ACCESS_TOKEN'],
        space: ENV['CONTENTFUL_SPACE_ID'],
        dynamic_entries: :auto,
        raise_errors: true,
        raise_for_empty_fields: false
      )
    end

    def render_all
      client.entries(content_type: content_type_id, include: 2)
    end

    def asset_by_id(id)
      client.entry(id)
    end

  end
end

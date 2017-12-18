module AttachableSerializer
  extend ActiveSupport::Concern

  included do
    has_many :attachments

    def attachments
      object.attachments.map(&:file)
    end
  end
end

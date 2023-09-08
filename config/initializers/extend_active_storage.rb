Rails.application.config.to_prepare do
  if defined?(ActiveStorage::Attachment)
    module ActiveStorageExtensions
      extend ActiveSupport::Concern

      class_methods do
        def ransackable_attributes(auth_object = nil)
          %w[blob_id created_at id name record_id record_type]
        end
      end
    end

    ActiveStorage::Attachment.include(ActiveStorageExtensions)
  end
end
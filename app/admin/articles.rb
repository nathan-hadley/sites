ActiveAdmin.register Article do
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  permit_params :title,
                :slug,
                :header_image_html,
                :content_html,
                :publish_date,
                :category

  member_action :upload, method: [:post] do
    result = { success: resource.images.attach(params[:file_upload]) }
    result[:url] = url_for(resource.images.last) if result[:success]
    render json: result
  end

  member_action :purge, method: :delete do
    image = ActiveStorage::Attachment.find(params[:image_id])
    image.purge
    redirect_back(fallback_location: edit_admin_article_path(resource), notice: "Image deleted.")
  end

  TOOLBAR_OPTS = [
    ['bold', 'italic', 'underline', 'strike'],
    ['blockquote', 'code-block'],
    [{ 'list': 'ordered'}, { 'list': 'bullet' }],
    [{ 'script': 'sub'}, { 'script': 'super' }], # superscript/subscript
    [{ 'indent': '-1'}, { 'indent': '+1' }], # outdent/indent
    [{ 'size': ['small', false, 'large'] }], # font size
    [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
    [{ 'color': [] }, { 'background': [] }], # dropdown with defaults from theme
    [{ 'align': [] }],
    ['image']
  ]

  # Active Admin article form conf:
  form do |f|
    f.inputs 'Article' do
      f.input :title
      f.input :slug
      f.input :header_image_html
      unless object.new_record?
        plugin_opts = { image_uploader: { server_url: upload_admin_article_path(object.id), field_name: 'file_upload' } }
        f.input :content_html, as: :quill_editor,
                input_html: {
                  data: {
                    plugins: plugin_opts,
                    options: {
                      modules: {
                        toolbar: TOOLBAR_OPTS
                      },
                    }
                  }
                }
      end
      f.input :publish_date
      f.input :category, as: :select, collection: Article::CATEGORIES
    end
    f.inputs 'Attached Images' do
      f.object.images.each do |image|
        div do
          span do
            image_tag(url_for(image), style: 'width: 200px; height:auto')  # Display image preview
          end
          br
          span do
            link_to "Delete", purge_admin_article_path(f.object, image_id: image.id), method: :delete
          end
        end
      end
    end
    f.actions
  end
end

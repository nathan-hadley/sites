ActiveAdmin.register Article do
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  permit_params do
    permitted = [:title, :slug, :header_image_html, :content_html, :publish_date, :category]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end

  # Active Admin article form conf:
  form do |f|
    f.inputs 'Article' do
      f.input :title
      f.input :slug
      f.input :header_image_html
      f.input :content_html, as: :quill_editor,
              input_html: {
                data: {
                  options: {
                    modules: {
                      toolbar: [
                        ['bold', 'italic', 'underline', 'strike'],
                        ['blockquote', 'code-block'],
                        [{ 'list': 'ordered'}, { 'list': 'bullet' }],
                        [{ 'script': 'sub'}, { 'script': 'super' }], # superscript/subscript
                        [{ 'indent': '-1'}, { 'indent': '+1' }], # outdent/indent
                        [{ 'direction': 'rtl' }], # text direction
                        [{ 'size': ['small', false, 'large'] }], # font size
                        [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
                        [{ 'color': [] }, { 'background': [] }], # dropdown with defaults from theme
                        [{ 'align': [] }],
                      ]
                    },
                  }
                }
              }
      f.input :publish_date
      f.input :category, as: :select, collection: Article::CATEGORIES
    end
    f.actions
  end
end

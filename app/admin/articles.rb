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
      f.input :content_html, as: :quill_editor
      f.input :publish_date
      f.input :category
    end
    f.actions
  end
end

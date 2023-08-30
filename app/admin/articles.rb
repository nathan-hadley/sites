ActiveAdmin.register Article do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  permit_params do
    permitted = [:title, :slug, :header_image_html, :content_html, :publish_data, :category]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end
end

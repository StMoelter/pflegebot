ActiveAdmin.register Provider do
  permit_params :active, :name, :host

  index do
    column :id
    column :name
    column :host
    column :active
    column :updated_at
    column :created_at
    actions
  end

  form(html: { multipart: true }) do |f|
    f.inputs 'Provider' do
      f.input :name
      f.input :host
      f.input :active
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :uuid
      row :name
      row :host
      row :updated_at
      row :created_at
    end
  end
end

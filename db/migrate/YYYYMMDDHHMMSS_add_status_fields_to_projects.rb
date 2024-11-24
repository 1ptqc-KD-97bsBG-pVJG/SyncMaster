class AddStatusFieldsToProjects < ActiveRecord::Migration[7.1]
    def change
      add_column :projects, :video_link, :string
      add_column :projects, :video_embedded, :boolean, default: false
      add_column :projects, :status, :string, default: 'open'
      add_column :projects, :customer_info_supplied, :boolean, default: false
      add_column :projects, :revision_requested, :boolean, default: false
      add_column :projects, :closed_by_id, :integer
      add_column :projects, :closed_at, :datetime
    end
  end
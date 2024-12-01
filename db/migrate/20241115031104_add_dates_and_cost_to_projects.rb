class AddDatesAndCostToProjects < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :cost, :float
    add_column :projects, :planning_completion_date, :date
    add_column :projects, :filming_completion_date, :date
    add_column :projects, :editing_completion_date, :date
    add_column :projects, :finalizing_completion_date, :date
    add_column :projects, :actual_completion_date, :date
    add_column :projects, :re_editing_completion_date, :date
    add_column :projects, :second_finalizing_completion_date, :date
  end
end

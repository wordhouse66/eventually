class AddStateToAttendance < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :state, :string
  end
end

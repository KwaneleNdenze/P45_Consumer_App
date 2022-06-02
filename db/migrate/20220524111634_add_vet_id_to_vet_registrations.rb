class AddVetIdToVetRegistrations < ActiveRecord::Migration[5.2]
  def change
    add_column :vet_registrations, :vet_id, :integer
  end
end

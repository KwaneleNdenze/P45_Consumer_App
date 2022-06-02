class CreateAppointments < ActiveRecord::Migration[5.2]
  def change
    create_table :appointments do |t|
      t.references :user, foreign_key: true
      t.references :pet, foreign_key: true
      t.integer :vet_id
      t.string :date

      t.timestamps
    end
  end
end

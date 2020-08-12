class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects, id: :uuid, default: -> { 'gen_random_uuid()' } do |t|
      t.string :name
      t.integer :status
      t.references :client, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end

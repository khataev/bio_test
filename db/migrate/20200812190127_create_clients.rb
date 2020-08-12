class CreateClients < ActiveRecord::Migration[6.0]
  def change
    create_table :clients, id: :uuid, default: -> { 'gen_random_uuid()' } do |t|
      t.string :name

      t.timestamps
    end
  end
end

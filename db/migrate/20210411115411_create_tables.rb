class CreateTables < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    create_table :users, id: :uuid, default: 'gen_random_uuid()' do |t|

      t.string :name, null: false
      t.string :password
    end

    create_table :scores, id: :uuid, default: 'gen_random_uuid()' do |t|

      t.string :points, null: false
      t.references :user, null: false
    end
  end
end

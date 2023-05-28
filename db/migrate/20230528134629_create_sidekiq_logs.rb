class CreateSidekiqLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :sidekiq_logs do |t|
      t.string :job_name, null: false
      t.string :items_added, array: true, default: [], null: false
      t.string :items_deleted, array: true, default: [], null: false
      t.datetime :job_performed, null: false

      t.timestamps
    end
  end
end

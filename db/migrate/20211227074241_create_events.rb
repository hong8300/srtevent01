class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.string :name,null: false, default: ""
      t.string :description,null: false, default: ""
      t.datetime :rec_starttime, null: true
      t.integer :status, null: false, default: 0
      t.string :output_filename, null: false, default: ""
      t.string :passphrase, null: false, default: ""
      t.string :server_url, null: false, default: ""
      t.string :server_port, null: false, default: ""
      t.string :sdata1, null: false, default: ""
      t.string :sdata2, null: false, default: ""
      t.integer :idata1, null: false, default: 0
  
      t.integer :idata2, null: false, default: 0
      t.timestamps
 
    end
  end
end

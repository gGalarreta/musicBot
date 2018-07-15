class CreateConversations < ActiveRecord::Migration[5.2]
  def change
    create_table :conversations do |t|
      t.string      :sender
      t.string      :recipient
      t.string      :text
      t.string      :payload
      t.belongs_to  :user
      t.timestamps
    end
  end
end

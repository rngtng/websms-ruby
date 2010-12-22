
class CreateSms < ActiveRecord::Migration
  def self.up
    create_table :sms do |t|
      t.boolean :received
      t.string :name
      t.string :tel
      t.datetime :date
      t.text :text
#      t.string :mail_id
      t.string :source
      t.integer :parent_msg_id
    end
  end
end
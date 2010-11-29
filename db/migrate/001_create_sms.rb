
class CreateSms < ActiveRecord::Migration
  def self.up
    create_table :sms do |t|
      t.string :sender_name
      t.string :sender_tel
      t.string :receiver_name
      t.string :receiver_tel
      t.datetime :date
      t.text :message
#      t.string :mail_id
      t.string :source
      t.string :parent_msg_id
#      t.string :

    end
  end
end
# frozen_string_literal: true

#  Copyright (c) 2020, CVP Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

class MigrateMailLog < ActiveRecord::Migration[6.0]

  def up
    change_table :mail_logs do |t|
      t.belongs_to :message
    end
    MailLog.reset_column_information
    to_bulk_mail_message
    remove_columns :mail_logs, :mailing_list_id, :mail_subject
  end

  def down
    add_column :mail_logs, :mail_subject, :string
    change_table :mail_logs do |t|
      t.belongs_to :mailing_list
    end
    MailLog.reset_column_information
    to_mail_log
    remove_column :mail_logs, :message_id
  end

  private

  def to_bulk_mail_message
    MailLog.find_each do |log|
      message_status = MailLog::BULK_MESSAGE_STATUS[log.status.to_sym]
      message = Message::BulkMail.new(subject: log.mail_subject,
                                      state: message_status,
                                      sent_at: log.updated_at,
                                      mailing_list_id: log.mailing_list_id)
      log.message = message
      log.save
    end
  end

  def to_mail_log
    Message.where(type: Message::BulkMail.sti_name).find_each do |m|
      m.mail_log.update!(mail_subject: m.subject, mailing_list_id: m.mailing_list_id)
      m.destroy!
    end
  end
end

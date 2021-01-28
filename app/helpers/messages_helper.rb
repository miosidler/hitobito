# frozen_string_literal: true

#  Copyright (c) 2021, CVP Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module MessagesHelper

  def add_message_button(type, path = path_args(model_class))
    label = [type.model_name.human, ti(:"link.add").downcase].join(' ')
    action_button(label,
                  new_polymorphic_path(path, message: { type: type }),
                  'plus')
  end

  def available_placeholders(editor_id)
    safe_join([
                  t('messages.form.available_placeholders'),
                  ' ',
                  safe_join(placeholder_links(editor_id), ', ')
              ])
  end

  def format_message_type(message)
    icon(message.class.icon, title: message.type.constantize.model_name.human)
  end

  def format_message_recipients_total(message)
    message.recipients_total.to_s
  end

  def format_message_state(message)
    type = case message.state
           when /pending|draft/ then 'info'
           when /processing/ then 'warning'
           when /finished/ then 'success'
           when /failed/ then 'important'
           end
    badge(message.state_label, type)
  end

  private

  def placeholder_links(editor_id)
    message_placeholders.map do |p|
      content_tag(:a,
                  "{#{p}}",
                  { data: { 'clickable-placeholder': editor_id } },
                  false).html_safe
    end
  end

  def message_placeholders
    Export::Pdf::Messages::Letter::Content.placeholders
  end
end

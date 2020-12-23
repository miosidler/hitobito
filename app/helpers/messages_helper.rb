# encoding: utf-8

#  Copyright (c) 2012-2014, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module MessagesHelper

  def message_icon(message)
    return :sms if message.is_a? Messages::TextMessage
    return :'envelope-open-text' if message.is_a? Messages::Letter
    :envelope
  end

  def format_message_type(message)
    icon(message_icon(message), title: message.model_name.human)
  end

end
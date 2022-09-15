# This module assigned to all database operations
module Database
  attr_accessor :db

  # This module assigned to create table action
  module Create
    def codes_to_full_message_list
      File.create("code_to_full.txt")
      true
    rescue SQLite3::SQLException
      false
    end
    def admin_list
      File.create("admin_list.txt")
      true
    rescue SQLite3::SQLException
      false
    end
    module_function(
        :codes_to_full_message_list,
        :admin_list
    )
  end

  def setup
    # Initializing database file
  end

  # Get all from the selected table
  # @var table_name
  def get_table(file_name, find)
    if File.exist? "#{file_name}.txt"

    else Listener.bot.api.send_message(chat_id: "", text: "File #{file_name}.txt is not exist")
    end
  end

  module_function(
    :get_table,
    :setup,
    :db,
    :db=
  )
end

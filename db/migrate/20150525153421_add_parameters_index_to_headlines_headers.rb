class AddParametersIndexToHeadlinesHeaders < ActiveRecord::Migration
  def change
    add_index :headlines_headers, :parameters, using: :gin
  end
end

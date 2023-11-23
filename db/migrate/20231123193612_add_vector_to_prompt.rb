# ElasticSearch integration doesn't work with transient attr_accessor attribute
# so adding column instead. Pretty sure there is a way to make it working, but
# not as part of this simple implementation

class AddVectorToPrompt < ActiveRecord::Migration[7.1]
  def change
    add_column :prompts, :feature_vector, :float, array: true, default: []
  end
end

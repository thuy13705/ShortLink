class CreateShortUrls < ActiveRecord::Migration[8.0]
   def change
    unless table_exists?(:short_urls)
      create_table :short_urls do |t|
        t.string :original_url
        t.string :short_code

        t.timestamps
      end
    end

    unless index_exists?(:short_urls, :short_code, unique: true)
      add_index :short_urls, :short_code, unique: true
    end
  end
end

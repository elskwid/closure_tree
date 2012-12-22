# encoding: UTF-8
class ActiveRecord::ConnectionAdapters::AbstractAdapter
  def force_add_index(table_name, columns, options = {})
    begin
      remove_index!(table_name, options[:name])
    rescue ActiveRecord::StatementInvalid, ArgumentError
    end
    add_index table_name, columns, options
  end
end

ActiveRecord::Schema.define(:version => 0) do

  create_table "tags", :force => true do |t|
    t.string "name"
    t.string "title"
    t.integer "parent_id"
    t.integer "sort_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tag_hierarchies", :id => false, :force => true do |t|
    t.integer "ancestor_id", :null => false
    t.integer "descendant_id", :null => false
    t.integer "generations", :null => false
  end

  create_table "destroyed_tags", :force => true do |t|
    t.string "name"
  end

  force_add_index "tag_hierarchies", [:ancestor_id, :descendant_id], :unique => true, :name => "tag_anc_desc_idx"
  force_add_index "tag_hierarchies", [:descendant_id], :name => "tag_desc_idx"

  create_table "users", :force => true do |t|
    t.string "email"
    t.integer "referrer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contracts", :force => true do |t|
    t.integer "user_id", :null => false
  end

  create_table "referral_hierarchies", :id => false, :force => true do |t|
    t.integer "ancestor_id", :null => false
    t.integer "descendant_id", :null => false
    t.integer "generations", :null => false
  end

  force_add_index "referral_hierarchies", [:ancestor_id, :descendant_id], :unique => true, :name => "ref_anc_desc_idx"
  force_add_index "referral_hierarchies", [:descendant_id], :name => "ref_desc_idx"

  create_table "labels", :force => true do |t|
    t.string "name"
    t.string "type"
    t.integer "sort_order"
    t.integer "mother_id"
  end

  create_table "label_hierarchies", :id => false, :force => true do |t|
    t.integer "ancestor_id", :null => false
    t.integer "descendant_id", :null => false
    t.integer "generations", :null => false
  end

  force_add_index "label_hierarchies", [:ancestor_id, :descendant_id], :unique => true, :name => "lh_anc_desc_idx"
  force_add_index "label_hierarchies", [:descendant_id], :name => "lh_desc_idx"

  create_table "cuisine_types", :force => true do |t|
    t.string "name"
    t.integer "parent_id"
  end

  create_table "cuisine_type_hierarchies", :id => false, :force => true do |t|
    t.integer "ancestor_id", :null => false
    t.integer "descendant_id", :null => false
    t.integer "generations", :null => false
  end

  create_table "pages", :force => true do |t|
    t.string "url"
    t.boolean "is_public"
    t.date "valid_from"
    t.date "valid_till"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer "parent_id"
    t.integer "sort_order"
    t.string "complete_url", :default => "/", :null => false
    t.string "header_image_file_name"
    t.string "header_image_content_type"
    t.integer "header_image_file_size"
    t.datetime "header_image_updated_at"
    t.boolean "use_for_navigation", :default => false
    t.boolean "show_breadcrumb", :default => true
    t.boolean "show_title", :default => true
  end

  force_add_index "pages", ["complete_url"], :name => "index_pages_on_complete_url"
  force_add_index "pages", ["parent_id"], :name => "index_pages_on_parent_id"

  create_table "page_hierarchies", :id => false, :force => true do |t|
    t.integer "ancestor_id", :null => false
    t.integer "descendant_id", :null => false
    t.integer "generations", :null => false
  end

  force_add_index "page_hierarchies", ["ancestor_id", "descendant_id"], :name => "index_page_hierarchies_on_ancestor_id_and_descendant_id", :unique => true
  force_add_index "page_hierarchies", ["descendant_id"], :name => "index_page_hierarchies_on_descendant_id"

  create_table :versions, :force => true do |t|
    t.string   :item_type, :null => false
    t.integer  :item_id,   :null => false
    t.string   :event,     :null => false
    t.string   :whodunnit
    t.text     :object
    t.datetime :created_at
  end

  force_add_index :versions, [:item_type, :item_id]

end

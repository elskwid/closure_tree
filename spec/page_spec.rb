require 'spec_helper'

describe "issue_28" do

  it "builds hash_tree properly" do
    id_to_parent = {
      16 => nil,
      30 => nil,
      35 => nil,
      36 => nil,
      37 => nil,
      40 => nil,

      21 => 16,
      24 => 16,
      27 => 16,
      31 => 30,
      34 => 30,

      22 => 21,
      23 => 21,
      25 => 24,
      26 => 24,
      28 => 27,
      29 => 27,
      32 => 31,
      33 => 31,

      38 => 23,
      39 => 26
    }
    id_to_parent.each do |id, parent_id|
      Page.create! do |t|
        t.id = id
        t.parent_id = parent_id
      end
    end
    Page.rebuild!
    root_ids = id_to_parent.select { |k, v| v.nil? }.keys
    roots = root_ids.collect { |ea| Page.find(ea) }
    # no second, third or forth level nodes:
    depth1 = Page.hash_tree(:limit_depth => 1)
    depth1.keys.should =~ roots
    # no third or forth level nodes:
    depth2 = Page.hash_tree(:limit_depth => 2)
    depth2.keys.should =~ roots
    second_level = depth2.values.collect { |ea| ea.keys }.flatten
    expected_root_children_ids = id_to_parent.select { |k, v| root_ids.include? v }.keys
    actual_root_children_ids = second_level.collect{|ea|ea.id}
    actual_root_children_ids.should =~ expected_root_children_ids
  end
end